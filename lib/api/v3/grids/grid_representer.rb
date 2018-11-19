#-- copyright
# OpenProject is a project management system.
# Copyright (C) 2012-2018 the OpenProject Foundation (OPF)
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2017 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See docs/COPYRIGHT.rdoc for more details.
#++

module API
  module V3
    module Grids
      class GridRepresenter < ::API::Decorators::Single
        link :page do
          {
            href: my_page_path,
            type: 'text/html'
          }
        end

        self_link title_getter: ->(*) { nil }

        property :row_count

        property :column_count

        property :widgets,
                 exec_context: :decorator,
                 getter: ->(*) do
                   represented.widgets.map do |widget|
                     WidgetRepresenter.new(widget, current_user: current_user)
                   end
                 end,
                 setter: ->(fragment:, **) do
                   represented.widgets = fragment.map do |widget_fragment|
                     WidgetRepresenter
                       .new(OpenStruct.new, current_user: current_user)
                       .from_hash(widget_fragment.with_indifferent_access)
                   end
                 end

        def _type
          'Grid'
        end
      end
    end
  end
end
