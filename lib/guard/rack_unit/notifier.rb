module Guard
  class RackUnit
    class Notifier

      DEFAULT_OPTIONS = {
        title: 'RackUnit Results',
      }.freeze

      def initialize(message)
        @message = message
      end

      def notify(options)
        ::Guard::Notifier.notify(@message,
                                 DEFAULT_OPTIONS.merge(options))
      end
    end
  end
end
