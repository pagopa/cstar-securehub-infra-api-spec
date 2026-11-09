"""Offline Listmonk public-route/policy checks. Requires Python + PyYAML.
Run: python scripts/validate_listmonk.py
"""
import re
import xml.etree.ElementTree as ET
from pathlib import Path
from urllib.parse import urlsplit

import yaml


ROOT = Path(__file__).resolve().parents[1]
MODULE = ROOT / "src/mcshared"
API = MODULE / "apim/api/listmonk"


def main():
    contract = yaml.safe_load((API / "openapi.yaml").read_text(encoding="utf-8"))
    assert contract["openapi"] == "3.0.3" and contract["security"] == []
    paths = contract["paths"]
    routes = [(method.upper(), path) for path, item in paths.items()
              for method in item if method in {"get", "post", "put", "patch", "delete", "options", "head"}]
    assert len(routes) == len(set(routes)) == 10
    ids = [item[method.lower()]["operationId"] for method, path in routes for item in [paths[path]]]
    assert len(ids) == len(set(ids))
    policy = ET.parse(API / "base_policy.xml").getroot()
    condition = policy.find("inbound/choose/when").attrib["condition"]
    uuid_pattern = re.search(r'IsMatch\(p.Value, "([^"]+)"', condition)[1]
    assert set(re.findall(r'p.Key == "([^"]+)"', condition)) == {"campUUID", "subUUID", "linkUUID"}
    uuid = "12345678-1234-1234-1234-123456789abc"

    def admitted(method, url):
        for verb, template in routes:
            pattern = re.escape(template)
            for param in re.findall(r"\{\w+\}", template):
                pattern = pattern.replace(re.escape(param), "([^/]+)")
            match = re.fullmatch(pattern, urlsplit(url).path)
            if method == verb and match and all(re.fullmatch(uuid_pattern, v) for v in match.groups()):
                return True
        return False

    for method in ("GET", "POST"):
        assert admitted(method, f"/subscription/{uuid}/{uuid}?manage=true")
    for path in ("/public/static/style.css?v=6.2.0", f"/campaign/{uuid}/{uuid}/px.png", f"/link/{uuid}/{uuid}/{uuid}"):
        assert admitted("GET", path)
    for path in ("/", "/admin", "/admin/login", "/api/settings", "/api/subscribers", "/health",
                 "/public/static/../admin", "/subscription/form", f"/subscription/optin/{uuid}",
                 f"/subscription/export/{uuid}", f"/subscription/../{uuid}", f"/subscription/%2fadmin/{uuid}"):
        for method in ("GET", "POST", "DELETE"):
            assert not admitted(method, path), (method, path)
    assert not admitted("DELETE", f"/subscription/{uuid}/{uuid}")
    rewrite_uri = policy.find("inbound/rewrite-uri").attrib
    assert rewrite_uri["copy-unmatched-params"] == "false"
    assert "OriginalUrl.ToString()).PathAndQuery" in rewrite_uri["template"]
    assert "Body.As" not in (API / "base_policy.xml").read_text(encoding="utf-8")
    rewrite = policy.find("outbound/choose/when/find-and-replace").attrib
    fixture = '<link href="/public/static/style.css?v=1"><script src="/public/custom.js?v=1"></script>'
    rewritten = fixture.replace(rewrite["from"], rewrite["to"])
    assert 'href="/listmonk/public/static/style.css?v=1"' in rewritten
    assert 'src="/listmonk/public/custom.js?v=1"' in rewritten
    assert not policy.findall(".//include-fragment"), "Keycloak fragments must not run on Listmonk requests"
    selection = (MODULE / "05_api_policy.tf").read_text(encoding="utf-8")
    assert "xml_content = each.value.api_policy.xml_content" in selection
    assert 'fragment-id="keycloak-token-inbound"' in (MODULE / "apim/api/base_policy.xml").read_text(encoding="utf-8")
    print("PASS Listmonk: ten explicit operations, public UUID routes, negative routes, query/body preservation, asset prefix, per-API policies")


if __name__ == "__main__":
    main()
