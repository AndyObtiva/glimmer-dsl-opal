require 'spec_helper'

module GlimmerSpec
  RSpec.describe 'tab' do
    include Glimmer
    
    it 'renders tabs' do
      person = Person.new
      Document.ready? do
        @target = shell {
          @tab_folder = tab_folder {
            @tab_item1 = tab_item {
              text "English"
              @label1 = label {
                text "Hello, World!"
              }
            }
            @tab_item2 = tab_item {
              text "French"
              @label2 = label {
                text "Bonjour, Univers!"
              }
            }
          }
        }
        @target.open
        
        expect(@tab_folder).to be_a(Glimmer::SWT::TabFolderProxy)
        expect(@tab_item1).to be_a(Glimmer::SWT::TabItemProxy)
        expect(@tab_item2).to be_a(Glimmer::SWT::TabItemProxy)
        
        expect(@tab_folder.children.to_a[0]).to eq(@tab_item1)
        expect(@tab_folder.children.to_a[1]).to eq(@tab_item2)
        
        expect(@tab_item1.text).to eq('English')
        expect(@tab_item2.text).to eq('French')
        
        expect(@tab_item1.children.to_a.first).to eq(@label1)
        expect(@tab_item2.children.to_a.first).to eq(@label2)
      end
    end    
  
  end
end
