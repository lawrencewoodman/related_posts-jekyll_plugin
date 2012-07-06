require 'test/unit'
require 'minitest/mock'
require 'minitest/spec'
require 'jekyll'
require_relative '../_plugins/related_posts'

def createPost(site, id, date, tags)
  file_dir = File.expand_path(File.dirname(__FILE__))
  post = Jekyll::Post.new(
    site, file_dir, 'source', "#{date}-post-#{id}.textile"
  )
  post.define_singleton_method(:id) {id}
  post.define_singleton_method(:tags) {tags}
  post
end

describe Jekyll::Post do
  before do
    @site = MiniTest::Mock.new
    @posts = []
    @posts << createPost(@site, 0, "2011-02-16", ['Retro', 'Programming'])
    @posts << createPost(@site, 1, "2011-08-16", ['Retro', 'Games'])
    @posts << createPost(@site, 2, "2011-08-20", ['Programming', 'Ruby'])
    @posts << createPost(@site, 3, "2011-01-16", ['Programming', 'C'])
    @posts << createPost(@site, 4, "2011-08-16", ['Off-topic', 'Funny', 'Story'])
    @posts << createPost(@site, 5, "2011-08-16", ['Programming', 'Games', 'C'])
    @posts << createPost(@site, 6, "2011-08-16", ['Retro', 'C'])
  end

  describe 'when given a post with nothing related' do
    it 'must return an empty array' do
      @posts[4].related_posts(@posts).must_equal []
    end
  end

  describe 'when given a post with more than one related post' do
    it 'must return related posts in order of relationship strength and date' do
      @posts[5].related_posts(@posts).must_equal [
        @posts[1], @posts[3], @posts[6], @posts[2], @posts[0]
      ]
    end

    it 'must return posts of equal relationship score in date order' do
      @posts[2].related_posts(@posts).must_equal [
        @posts[5], @posts[0], @posts[3]
      ]
    end
  end

end
