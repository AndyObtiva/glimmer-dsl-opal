# Copyright (c) 2020 Andy Maleh
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

require 'glimmer/swt/control_editor'

module Glimmer
  module SWT
    # Emulates SWT's native org.eclipse.swt.custom.TableEditor
    class TableEditor < ControlEditor
      alias table composite
      
      def editor=(editor_widget, table_item, table_column_index)
        # TODO consider making editor not gain an ID or gain a separate set of IDs to avoid clashing with standard widget predictability of ID
        @table_item = table_item
        @table_column_index = table_column_index
        @editor_widget = editor_widget
        @old_value = table_item.cell_dom_element(table_column_index).html
        table_item.cell_dom_element(table_column_index).html('')
        editor_widget.render(table_item.cell_dom_element(table_column_index))
        # TODO tweak the width perfectly so it doesn't expand the table cell
#         editor_widget.dom_element.css('width', 'calc(100% - 20px)')
        editor_widget.dom_element.css('width', '98%') # just a good enough approximation
        editor_widget.dom_element.css('height', '11px')
        editor_widget.dom_element.add_class('table-editor')
        editor_widget.dom_element.focus
        editor_widget.dom_element.select
      end
      alias set_editor editor=
      alias setEditor editor=
      
      def cancel!
        @table_item.cell_dom_element(@table_column_index).html(@old_value) unless @old_value.nil?
      end
      
      def save!(widget_value_property: 'text')
        @table_item.cell_dom_element(@table_column_index).html(@editor_widget.send(widget_value_property))
        @old_value = nil
      end
    end
  end
end
