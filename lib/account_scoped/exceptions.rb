module AccountScoped
  class Exception < RuntimeError
  end

  class UserRequired < Exception
    attr_accessor :session

    def initialize(session = nil, message = 'A session user is required in context')
      super(message)
      self.session = session
    end
  end

end
