module BootstrapForm
  module Helper

    def bootstrap_form_for(object, options = {}, &block)
      options.reverse_merge!({builder: BootstrapForm::FormBuilder})

      options = process_options(options)

      temporarily_disable_field_error_proc do
        form_for(object, options, &block)
      end
    end

    def bootstrap_form_tag(options = {}, &block)
      bootstrap_form_for(options[:as].to_s, options, &block)
    end

    def bootstrap_form_with(options = {}, &block)
      options.reverse_merge!(builder: BootstrapForm::FormBuilder)

      options = process_options(options)

      temporarily_disable_field_error_proc do
        form_with(options, &block)
      end
    end
    
    def bootstrap_fields_for(record_name, record_object = nil, options = {}, &block)
      options.reverse_merge!(builder: BootstrapForm::FormBuilder)
      
      temporarily_disable_field_error_proc do
        fields_for(record_name, record_object, options, &block)
      end
    end
      
    private

    def process_options(options)
      options[:html] ||= {}
      options[:html][:role] ||= 'form'

      if options[:layout] == :inline
        options[:html][:class] = [options[:html][:class], 'form-inline'].compact.join(' ')
      end

      options
    end

    public

    def temporarily_disable_field_error_proc
      original_proc = ActionView::Base.field_error_proc
      ActionView::Base.field_error_proc = proc { |input, instance| input }
      yield
    ensure
      ActionView::Base.field_error_proc = original_proc
    end
  end
end
