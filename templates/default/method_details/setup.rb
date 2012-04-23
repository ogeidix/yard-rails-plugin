def init
  super
  sections.last.place(:routes).before(:source)
  sections.last.place(:params).after(:routes)
end
