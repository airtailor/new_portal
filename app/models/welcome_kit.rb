class WelcomeKit < Order
  after_initialize :init

  def init
    self.source = "Shoppify"
  end
end
