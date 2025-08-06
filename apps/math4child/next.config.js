/** @type {import("next").NextConfig} */
const nextConfig = {
  images: {
    domains: ["images.unsplash.com"],
  },
  env: {
    NEXT_PUBLIC_APP_NAME: "Math4Child",
    NEXT_PUBLIC_APP_VERSION: "4.0.0",
    NEXT_PUBLIC_DOMAIN: "https://www.math4child.com",
    NEXT_PUBLIC_COMPANY: "GOTEST",
    NEXT_PUBLIC_SIRET: "53958712100028",
    NEXT_PUBLIC_CONTACT_EMAIL: "gotesttech@gmail.com"
  },
  async headers() {
    return [
      {
        source: "/(.*)",
        headers: [
          {
            key: "X-Frame-Options",
            value: "DENY",
          },
          {
            key: "X-Content-Type-Options",
            value: "nosniff",
          },
          {
            key: "Referrer-Policy",
            value: "strict-origin-when-cross-origin",
          },
        ],
      },
    ]
  },
}

module.exports = nextConfig
