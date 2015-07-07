require 'rails_helper'

describe ApplicationHelper do
  context 'strip_html_content' do
    it 'should strip html tags, carriage return, line space, images, links' do
      content = "<p class=\'body\' style=\'outline: 0px; margin-top: 0px; color: rgb(59, 58, 57); font-family: Georgia, 'Times New Roman', Times, serif; font-size: 14px; line-height: 18px;\'>
                <img alt=\'\' src=\'http://s3.amazonaws.com/ckeditor_image_development/ckeditor/pictures/data/000/000/007/content/10492214_956709314392784_1152015642970785087_n.jpg\' style=\'width: 479px; height: 480px;\' />
                </p>\r\n\r\n<p class='x'> Madhya Pradesh </p>"
      expect(helper.strip_html_content(content)).to eq('Madhya Pradesh')
    end
  end
end