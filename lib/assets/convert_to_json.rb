class ConvertToJson
  def self.procedures(params)
    procedures = {}
    (1..10).each do |i|
      procedures[:"procedure_#{i}"] = ''
      procedures[:"procedure_#{i}"] = params[:"procedure_#{i}"] if params[:"procedure_#{i}"].present?
    end
    procedures.to_json
  end

  def self.procedure_imgs(params)
    imgs = {}
    (1..10).each do |i|
      imgs[:"procedure_img_#{i}"] = params[:"procedure_img_#{i}"]
    end
    imgs.to_json
  end

  def self.procedure_img_txts(params)
    txts = {}
    (1..10).each do |i|
      txts[:"procedure_img_txt_#{i}"] = params[:"procedure_img_txt_#{i}"]
    end
    txts.to_json
  end

  def self.supplementary_imgs(params)
    imgs = {}
    num = params[:supplementary_img_num].to_i
    (1..num).each do |i|
      # imgs[:"supplementary_img_#{i}"] = '0'
      # imgs[:"supplementary_img_#{i}"] = '1' if params[:"supplementary_img_#{i}"].present?
      # if params[:"supplementary_img_#{i}"].present?
      #   imgs[:"supplementary_img_#{num}"] = '1'
      #   num += 1
      # end
      imgs[:"supplementary_img_#{i}"] = '1'
    end
    (num+1..10).each do |i|
      imgs[:"supplementary_img_#{i}"] = '0'
    end

    [imgs[:supplementary_img_1],
     imgs[:supplementary_img_2],
     imgs[:supplementary_img_3],
     imgs[:supplementary_img_4],
     imgs[:supplementary_img_5],
     imgs[:supplementary_img_6],
     imgs[:supplementary_img_7],
     imgs[:supplementary_img_8],
     imgs[:supplementary_img_9],
     imgs[:supplementary_img_10]].reject(&:blank?).to_json
  end

  def self.preservation_supplementary_imgs(params)
    imgs = {}
    num = params[:supplementary_img_num].to_i
    (1..num).each do |i|
      # imgs[:"supplementary_img_#{i}"] = '0'
      # imgs[:"supplementary_img_#{i}"] = '1' if params[:"supplementary_img_#{i}"].present?
      # if params[:"supplementary_img_#{i}"].present?
      #   imgs[:"supplementary_img_#{num}"] = '1'
      #   num += 1
      # end
      imgs[:"supplementary_img_#{i}"] = params[:"supplementary_img_src_#{i}"]
    end
    (num+1..10).each do |i|
      imgs[:"supplementary_img_#{i}"] = '0'
    end

    [imgs[:supplementary_img_1],
     imgs[:supplementary_img_2],
     imgs[:supplementary_img_3],
     imgs[:supplementary_img_4],
     imgs[:supplementary_img_5],
     imgs[:supplementary_img_6],
     imgs[:supplementary_img_7],
     imgs[:supplementary_img_8],
     imgs[:supplementary_img_9],
     imgs[:supplementary_img_10]].reject(&:blank?).to_json
  end

  def self.supplementary_img_txts(params)
    txts = {}
    num = params[:supplementary_img_num].to_i
    (1..num).each do |i|
      if params[:"supplementary_img_txt_#{i}"].present?
        txts[:"supplementary_img_txt_#{i}"] = params[:"supplementary_img_txt_#{i}"]
      else
        txts[:"supplementary_img_txt_#{i}"] = ''
      end
    end
    (num+1..10).each do |i|
      txts[:"supplementary_img_txt_#{i}"] = ''
    end
    # (1..10).each do |i|
    #   txts[:"supplementary_img_txt_#{i}"] = ''
    #   txts[:"supplementary_img_txt_#{i}"] = params[:"supplementary_img_txt_#{i}"] if params[:"supplementary_img_txt_#{i}"].present?
    #   if params[:"supplementary_img_#{i}"].present?
    #     if params[:"supplementary_img_txt_#{i}"].present?
    #       txts[:"supplementary_img_txt_#{num}"] = params[:"supplementary_img_txt_#{i}"]
    #     else
    #       txts[:"supplementary_img_txt_#{num}"] = ''
    #     end
    #     num += 1
    #   end
    #   p txts[:"supplementary_img_txt_#{num}"]
    # end
    # (num..10).each do |i|
    #   txts[:"supplementary_img_txt_#{i}"] = ''
    # end

    [txts[:supplementary_img_txt_1],
     txts[:supplementary_img_txt_2],
     txts[:supplementary_img_txt_3],
     txts[:supplementary_img_txt_4],
     txts[:supplementary_img_txt_5],
     txts[:supplementary_img_txt_6],
     txts[:supplementary_img_txt_7],
     txts[:supplementary_img_txt_8],
     txts[:supplementary_img_txt_9],
     txts[:supplementary_img_txt_10]]
    # txts.to_json

  end

  def self.malfunction_codes(params)
    (1..5).each do |i|
      if params[:"malfunction_code_#{i}"].present?
      else
        params[:"malfunction_code_#{i}"] = ''
      end
    end

    [params[:malfunction_code_1],
     params[:malfunction_code_2],
     params[:malfunction_code_3],
     params[:malfunction_code_4],
     params[:malfunction_code_5]].to_json
  end

  def self.malfunction_code_epats(params)
    (1..5).each do |i|
      if params[:"introduction_code_#{i}"].present?
      else
        params[:"introduction_code_#{i}"] = ''
      end
    end
    [params[:introduction_code_1],
     params[:introduction_code_2],
     params[:introduction_code_3],
     params[:introduction_code_4],
     params[:introduction_code_5]].to_json
  end
end
