# basketcraft
this is a script that exploits the CVE-2023-27163 vulnerability which is an SSRF in the request-baskets version 1.2.1

# SSRF on Request-Baskets (CVE-2023–27163)
CVE-2023–27163 represents a critical Server-Side Request Forgery (SSRF) vulnerability that was identified in Request-Baskets, affecting all versions up to 1.2.1. This particular vulnerability grants malicious actors the ability to gain unauthorized access to network resources and sensitive information by exploiting the /api/baskets/{name} component through carefully crafted API requests.

# How it works
Request-Baskets is a web application designed to collect and log incoming HTTP requests directed to specific endpoints known as “baskets”. During the creation of these baskets, users have the flexibility to specify alternative servers to which these requests should be forwarded. The critical issue is that users can inadvertently specify services they shouldn’t have access to, including those typically restricted within a network environment.

For example, we have a request server running Request-Baskets on port 55555 and simultaneously run a Flask web server on port 2054 The Flask server, however, is configured to exclusively interact with the internal network, with this in mind the attacker can exploit the SSRF vulnerability by creating a basket that forwards requests to http://internal_network:2054, effectively bypassing the previous network restrictions and gaining access to the Flask web server, which should have been restricted to internal network access only.
