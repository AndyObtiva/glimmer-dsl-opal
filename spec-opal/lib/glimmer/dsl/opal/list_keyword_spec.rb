require 'spec_helper'

module GlimmerSpec
  RSpec.describe 'list keyword' do
    include Glimmer
    
    let(:title) {'Hello, World!'}
        
    it 'renders and binds list widget for single selection' do
      person = Person.new
      Document.ready? do
        @target = shell {
          @list = list {
            selection bind(person, :country)
          }
        }
        @target.open
        
        expect(@list).to be_a(Glimmer::SWT::ListProxy)
         
        list_element = Document.find('body > div#shell-1.shell > ul#list-1.list').first
        expect(list_element).to be_a(Element)
        
        selected_list_item_element = Document.find('body > div#shell-1.shell > ul#list-1.list > li.selected').first
        expect(selected_list_item_element).to be_a(Element)
        expect(selected_list_item_element.html).to eq(person.country)
         
        person.country = 'US'
        selected_list_item_element = Document.find('body > div#shell-1.shell > ul#list-1.list > li.selected').first
        expect(selected_list_item_element.html).to eq('US')
         
        new_selected_list_item_element = Document.find('body > div#shell-1.shell > ul#list-1.list > li:nth-child(4)').first
        expect(new_selected_list_item_element.html).to eq('Mexico')
        new_selected_list_item_element.trigger(:click)
         
        expect(person.country).to eq('Mexico')
      end
    end    
  end
end
