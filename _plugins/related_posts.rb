require 'jekyll/post'

module RelatedPosts

  # Used to remove #related_posts so that it can be overridden
  def self.included(klass)
    klass.class_eval do
      remove_method :related_posts
    end
  end

  # Calculate related posts.
  #
  # Returns [<Post>]
  def related_posts(posts)
    return [] unless posts.size > 1
    highest_freq = Jekyll::Post.category_freq(posts).values.max
    related_score = Hash.new(0)
    posts.each do |post|
      post.categories.each do |category|
        if self.categories.include?(category) && post != self
          cat_freq = Jekyll::Post.category_freq(posts)[category]
          related_score[post] += (1+highest_freq-cat_freq)
        end
      end
    end

    related_score.sort {|a,b| b[1] <=> a[1]}.collect {|post,freq| post}
  end

  module ClassMethods
    # Calculate the frequency of each category.
    #
    # Returns {category => freq, category => freq, ...}
    def category_freq(posts)
      return @category_freq if @category_freq
      @category_freq = Hash.new(0)
      posts.each do |post|
        post.categories.each {|category| @category_freq[category] += 1}
      end
      @category_freq
    end
  end

end

module Jekyll
  class Post
    include RelatedPosts
    extend RelatedPosts::ClassMethods
  end
end
