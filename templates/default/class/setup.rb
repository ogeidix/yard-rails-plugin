def init
  super
  sections.place(:routes).before(:children)
end
