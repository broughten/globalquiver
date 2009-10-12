Given /^the following user record$/ do |table|
  table.hashes.each do |hash|
    Surfer.make(hash)
  end
end
