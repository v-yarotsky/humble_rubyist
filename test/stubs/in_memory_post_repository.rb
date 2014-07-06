require 'delegate'

class TestPostRepo < DelegateClass(Array)
  def initialize(posts = [])
    super
  end

  def push(post)
    exists = detect { |p| p.id == post.id }
    exists ? (raise HumbleRubyist::Armchair::DuplicatePost) : super
  end
end

