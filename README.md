# Shypple Assignment

With this Rails app, I aim to automate the calculation of shipping options, ensuring fast and cost-effective deliveries.

### Environment

- Ruby version: 3.3.0
- Rails version: 7.0.8.1
- Database: Postgres
- Testing: RSpec
- Code Coverage: SimpleCov
- Linter: Rubocop

### Installation

  - Clone the repository
  - Run `bundle install`
  - Run `rails db:create`
  - Run `rails db:migrate`
  - Run `rake import:json_data FILE_PATH=db/initial_data.json`

### Usage

  - Run `rails c` to open the Rails console

  1. PLS-0001 - Return the cheapest direct sailing between origin port & destination port in following format.  
      `ap  SailingCalculator::CheapestDirectSailingService.new('CNSHA', 'NLRTM').call.result`

  2. WRT-0002 - Return the cheapest sailing (direct or indirect).  
       `ap  SailingCalculator::CheapestSailingService.new('CNSHA', 'NLRTM').call.result`

  3. TST-0003 - Return the fastest sailing legs (direct or indirect).  
        `ap  SailingCalculator::FastestSailingService.new('CNSHA', 'NLRTM').call.result`

### Testing

  - Run `rspec` to run the test suite.
  - Check the coverage by running `open coverage/index.html`

### Assumptions
 - Each sailing option can have multiple sailing codes that refers to different currencies.
 - For TST-0003, it calculates the fastest sailing legs based on the total transit time which includes the time spent by freight on land between multiple sailing legs.
 - For simplicity, I have created only services for now. These services can be called via individual rake tasks or can be integrated with the API.
 - I have created a rake task for now to import JSON data given by MapReduce team to the database. We can have an API that fetches the data directly from the MapReduce team.
