# AccountScoped

ActiveRecord multi-tenancy based on account_id scope.

## Installation

Add this line to your application's Gemfile:

    gem 'account_scoped'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install account_scoped

## Usage

Add `account_scoped` in your models and controllers:

```ruby
class Posts < ActiveRecord::Base
   account_scoped

   has_many :comments
end
```

```ruby
class PostsController < ApplicationController
   account_scoped

   def index
     @posts = Post.all # will be automatically scoped .where(account_id: session[:account_id])
   end

   def show
     @post = Post.find params[:id] # will also be scoped .where(account_id: session[:account_id])
   end

   def create
     @post = Post.create params[:id] # will automatically assign account_id as session[:account_id]
   end
end
```

For models the default scope is dynamicaly scoped based on presence of session[:account_id]. 
Controllers automatically hook before_filter to read the `session[:account_id]`

## TODO

- [ ] configure field name and session value name (ie. `accoutn_id`)
- [ ] support `:except` and `:only` for controllers' `:before_filter`

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
