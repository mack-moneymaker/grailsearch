# GrailSearch

Find your grails across every resale platform. Search Vinted, eBay, Depop, Grailed, Vestiaire Collective & Poshmark from one place.

## Stack

- Ruby 4.0.1 / Rails 8.1
- PostgreSQL
- Tailwind CSS
- SolidQueue for background jobs

## Features

- **Multi-platform search** — aggregates results from eBay (API) and Vinted (scraping), with direct links to Depop, Grailed, Vestiaire Collective, and Poshmark
- **Saved searches** — save your search criteria and get notified when new listings appear
- **Email alerts** — background jobs check saved searches hourly and email you new results
- **Price tracking** — price history and trends for popular items
- **User accounts** — signup/login with free and Pro tiers

## Setup

```bash
bin/setup
rails db:create db:migrate
rails server
```

## Environment Variables

- `EBAY_APP_ID` — eBay developer app ID
- `EBAY_CERT_ID` — eBay developer cert ID
- `STRIPE_SECRET_KEY` — Stripe secret key (for Pro subscriptions)

## License

Proprietary.
