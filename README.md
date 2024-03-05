# Project Documentation

## Overview

The application includes a series of RESTful API endpoints catering to product lifecycle management, including listing active products, searching for products based on various criteria, creating, updating, and deleting products, as well as managing an approval queue for products based on specific business rules.

It follows Test Driven Development, tests are located in https://github.com/SyedAman/RetailApp/blob/master/spec/requests/products_spec.rb

## System Dependencies & Configuration`

The application is built using Ruby on Rails, adhering to the MVC architectural pattern. Below are the key dependencies used:

- Ruby version: 3.x
- Rails version: 7.x
- Database: SQLite3 (Development & Test), PostgreSQL (Production)
- Testing Framework: RSpec, FactoryBot
- Linters: RuboCop

To set up the project for local development/testing:

1. Clone the repository to your local machine.
2. Run `bundle install` to install Ruby gems.
3. Set up the database with `rails db:create db:migrate`.
4. Start the Rails server using `rails s`.

## API Endpoints and Usage

The application provides the following API endpoints:

1. `GET /api/products`: Lists all active products, sorted by the most recent.
2. `GET /api/products/search`: Searches for products based on name, price range, and posted date range.
3. `POST /api/products`: Creates a new product (with validations).
4. `PUT /api/products/:id`: Updates an existing product.
5. `DELETE /api/products/:id`: Deletes a product and adds it to the approval queue.
6. `GET /api/products/approval-queue`: Retrieves all products in the approval queue, sorted by request date.
7. `PUT /api/products/approval-queue/:id/approve`: Approves a product from the approval queue.
8. `PUT /api/products/approval-queue/:id/reject`: Rejects a product from the approval queue.

## Testing Strategy

Our testing strategy employs RSpec, a Domain-Specific Language (DSL) testing tool written in Ruby for behavior-driven development (BDD). We have meticulously created tests to cover all API functionalities, ensuring high reliability and stability of our application.

The test suite is located in the `spec/` directory, organized into:

- `spec/models/`: Unit tests for model validations and business logic.
- `spec/requests/`: Integration tests for API endpoints, ensuring they perform as expected.

To run the test suite, execute:

```shell
bundle exec rspec
```

This command will run all specs and output a detailed report, indicating the success or failure of each test.

