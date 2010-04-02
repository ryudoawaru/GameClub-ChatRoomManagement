require 'rexml/document'
class Array
  
  def write_excel_xml(filename, worksheet_name, col_attrs = nil)
    open(filename, 'w') do |f|
      self.to_excel_xml(worksheet_name, col_attrs).write f
    end
  end
  
  def to_excel_xml(worksheet_name, col_attrs = nil)
    doc = REXML::Document.new(  
      '<?xml version="1.0" encoding="utf-8"?> 
      <Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet" 
       xmlns:o="urn:schemas-microsoft-com:office:office" 
       xmlns:x="urn:schemas-microsoft-com:office:excel" 
       xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" 
       xmlns:html="http://www.w3.org/TR/REC-html40"></Workbook>')
    worksheetNode = REXML::Element.new 'Worksheet'
    worksheetNode.attributes['ss:Name'] = worksheet_name
    tableNode = REXML::Element.new 'Table'
    colnames = col_attrs || self.first.class.column_names #設定要讀取之屬性名稱
    rowNode = REXML::Element.new 'Row'
    colnames.each do |col_name|
      dataNode = REXML::Element.new 'Data'  
      dataNode.attributes['ss:Type'] = 'String'
      dataNode.text = self.first.class.human_attribute_name(col_name.to_s)
      cellNode = REXML::Element.new 'Cell'  
      cellNode.add_element dataNode  
      rowNode.elements << cellNode
    end
    tableNode.elements << rowNode
    self.each_with_index do |db_row, idx|
      rowNode = REXML::Element.new 'Row'
      
      colnames.each do |col_name|
        dataNode = REXML::Element.new 'Data'  
        dataNode.attributes['ss:Type'] = 'String'
        d = db_row.send(col_name)
        if d.is_a?(Time)
          #dataNode.attributes['ss:Type'] = 'DateTime'
          dataNode.text = d.strftime('%y-%m-%d %H:%M:%S')
        else
          if d.is_a?(Date)
            #dataNode.attributes['ss:Type'] = 'DateTime'
            dataNode.text = d.strftime('%y-%m-%d')
          else
#            if d.is_a?(Numeric)
#              dataNode.attributes['ss:Type'] = 'Number'
#            else
#              dataNode.attributes['ss:Type'] = 'String'
#            end
            dataNode.text = d.to_s
          end
        end
        cellNode = REXML::Element.new 'Cell'  
        cellNode.add_element dataNode  
        rowNode.elements << cellNode  
      end
      tableNode.elements << rowNode
    end
    worksheetNode.elements << tableNode  
    doc.root.add_element worksheetNode
    return doc
  end
  
  def rand_members(amount = 0)
    return nil if amount == 0
    return self.shuffle if amount >= self.size
    idx = Kernel.rand(self.size - amount + 1)
    return self[idx..(idx + amount - 1)]#.sort_by{ rand }
  end
  
  def shuffle
    sort_by { rand }
  end

  def shuffle!
    self.replace shuffle
  end

  def unflatten(cols)
    return self if self.empty?
    arr = self
    if arr.size < cols
      (cols - arr.size).times do
        arr << nil
      end
      arr = [arr]
      return arr
    end
    newarr = []
    (arr.size / cols).times do
      a = []
      cols.times do
        a << arr.shift
      end
      newarr << a
    end
    modn = arr.size % cols
    if modn > 0
      a = []
      modn.times do
        a << arr.shift
      end
      (cols - modn).times do
        a << nil
      end
      newarr << a
    end
    return newarr
  end
  
  def unflatten!(cols)
    self.replace unflatten
  end
  
  def autofill(size)
    return self if size < self.size
    (size - self.size).times do
      self << nil
    end
    self
  end
  
  def self.zip(*args)
    max_size = 0
    args.each do |ar|
      max_size = ar.size if ar.size > max_size
    end
    res = []
    max_size.times do |yidx|
      row = []
      args.size.times do |xidx|
        if args[xidx].size > yidx
          row << args[xidx][yidx]
        else
          row << nil
        end
      end
      res << row
    end
    return res
  end
  
end