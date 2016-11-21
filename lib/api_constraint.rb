# => ApiContrains for different Api Versions
class ApiConstraint
  def initialize(options)
    @version  = options.fetch(:version)
    @default  = options.fetch(:default)
  end

  def matches?(req)
    @default || req.headers['Accept'].include?("version=#{@version}")
  end

end