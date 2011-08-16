require 'test/unit'
require 'minitest/mock'
require 'minitest/spec'
require 'jekyll'
require_relative '../_plugins/related_posts'

def createPost(site, id, categories)
  file_dir = File.expand_path(File.dirname(__FILE__))
  post = Jekyll::Post.new(
    site, file_dir, 'source', "2011-08-16-post-#{id}.textile"
  )
  post.define_singleton_method(:id) {id}
  post.define_singleton_method(:categories) {categories}
  post
end

describe Jekyll::Post do
  before do
    @site = MiniTest::Mock.new
    @posts = []
    @posts << createPost(@site, 0, ['Retro', 'Programming'])
    @posts << createPost(@site, 1, ['Retro', 'Games'])
    @posts << createPost(@site, 2, ['Programming', 'Ruby'])
    @posts << createPost(@site, 3, ['Programming', 'C'])
    @posts << createPost(@site, 4, ['Off-topic', 'Funny', 'Story'])
    @posts << createPost(@site, 5, ['Programming', 'Games', 'C'])
    @posts << createPost(@site, 6, ['Retro', 'C'])
  end

  describe 'when given a post with nothing related' do
    it 'must return an empty array' do
      @posts[4].related_posts(@posts).must_equal []
    end
  end

  describe 'when given a post with more than one related post' do
    it 'must return related posts in order of relationship strength' do
      @posts[5].related_posts(@posts).must_equal [
        @posts[3], @posts[1], @posts[6], @posts[2], @posts[0]
      ]
    end
  end

end
