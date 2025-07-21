#!/bin/bash

# Script de vérification DNS pour math4child.com
# Utilisation: ./check-dns.sh

echo "🌐 VÉRIFICATION DNS POUR MATH4CHILD.COM"
echo "========================================"

# Couleurs pour output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

domain="math4child.com"
www_domain="www.math4child.com"
netlify_url="687c49209cf9ccff4c3d191c--math4kids-enhanced.netlify.app"

echo ""
echo -e "${BLUE}1. Test de résolution DNS${NC}"
echo "----------------------------"

# Test DNS principal
echo -n "Résolution $domain: "
if nslookup $domain > /dev/null 2>&1; then
    echo -e "${GREEN}✅ OK${NC}"
    nslookup $domain | grep -A 5 "Name:"
else
    echo -e "${RED}❌ ÉCHEC${NC}"
fi

echo ""
echo -n "Résolution $www_domain: "
if nslookup $www_domain > /dev/null 2>&1; then
    echo -e "${GREEN}✅ OK${NC}"
    nslookup $www_domain | grep -A 5 "Name:"
else
    echo -e "${RED}❌ ÉCHEC${NC}"
fi

echo ""
echo -e "${BLUE}2. Test de connectivité HTTP${NC}"
echo "--------------------------------"

# Test HTTP principal
echo -n "Connexion https://$domain: "
if curl -s -I "https://$domain" > /dev/null 2>&1; then
    status=$(curl -s -I "https://$domain" | head -n 1 | cut -d' ' -f2)
    echo -e "${GREEN}✅ Status: $status${NC}"
else
    echo -e "${RED}❌ ÉCHEC${NC}"
fi

# Test HTTP www
echo -n "Connexion https://$www_domain: "
if curl -s -I "https://$www_domain" > /dev/null 2>&1; then
    status=$(curl -s -I "https://$www_domain" | head -n 1 | cut -d' ' -f2)
    echo -e "${GREEN}✅ Status: $status${NC}"
else
    echo -e "${RED}❌ ÉCHEC${NC}"
fi

echo ""
echo -e "${BLUE}3. Test de redirection${NC}"
echo "---------------------------"

# Test redirection www vers non-www
echo -n "Redirection www → non-www: "
redirect_location=$(curl -s -I "https://$www_domain" | grep -i location | cut -d' ' -f2 | tr -d '\r')
if [[ "$redirect_location" == "https://$domain"* ]]; then
    echo -e "${GREEN}✅ OK${NC}"
else
    echo -e "${YELLOW}⚠️  Vérifier redirection${NC}"
fi

echo ""
echo -e "${BLUE}4. Test SSL/TLS${NC}"
echo "----------------"

# Test SSL
echo -n "Certificat SSL $domain: "
if echo | openssl s_client -servername $domain -connect $domain:443 2>/dev/null | openssl x509 -noout -dates > /dev/null 2>&1; then
    echo -e "${GREEN}✅ OK${NC}"
    echo | openssl s_client -servername $domain -connect $domain:443 2>/dev/null | openssl x509 -noout -subject -dates
else
    echo -e "${RED}❌ ÉCHEC${NC}"
fi

echo ""
echo -e "${BLUE}5. Propagation DNS globale${NC}"
echo "----------------------------"

# Test propagation avec différents serveurs DNS
dns_servers=("8.8.8.8" "1.1.1.1" "208.67.222.222")
for dns in "${dns_servers[@]}"; do
    echo -n "DNS $dns: "
    if nslookup $domain $dns > /dev/null 2>&1; then
        ip=$(nslookup $domain $dns 2>/dev/null | awk '/^Address: / { print $2 }' | tail -1)
        echo -e "${GREEN}✅ $ip${NC}"
    else
        echo -e "${RED}❌ Non résolu${NC}"
    fi
done

echo ""
echo -e "${BLUE}6. URL Netlify temporaire${NC}"
echo "----------------------------"

echo -n "Netlify temporaire: "
if curl -s -I "https://$netlify_url" > /dev/null 2>&1; then
    status=$(curl -s -I "https://$netlify_url" | head -n 1 | cut -d' ' -f2)
    echo -e "${GREEN}✅ Status: $status${NC}"
    echo "   URL: https://$netlify_url"
else
    echo -e "${RED}❌ ÉCHEC${NC}"
fi

echo ""
echo -e "${BLUE}7. Recommandations${NC}"
echo "-------------------"

if ! nslookup $domain > /dev/null 2>&1; then
    echo -e "${YELLOW}⚠️  DNS non configuré - Ajouter les enregistrements CNAME${NC}"
    echo "   CNAME @ → $netlify_url"
    echo "   CNAME www → $netlify_url"
fi

if ! curl -s -I "https://$domain" > /dev/null 2>&1; then
    echo -e "${YELLOW}⚠️  Site non accessible - Vérifier configuration Netlify${NC}"
    echo "   1. Ajouter domaine personnalisé dans Netlify"
    echo "   2. Attendre provisioning SSL (jusqu'à 24h)"
fi

echo ""
echo -e "${GREEN}✅ Vérification terminée${NC}"
echo ""
echo "💡 En cas de problème:"
echo "   - Attendre propagation DNS (2-48h)"
echo "   - Vider cache DNS local: sudo dscacheutil -flushcache"
echo "   - Tester depuis: https://dnschecker.org"