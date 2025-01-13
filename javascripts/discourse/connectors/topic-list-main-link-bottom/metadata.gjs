import TopicExcerpt from "../../components/topic-excerpt";
import TopicMetadata from "../../components/topic-metadata";
import TopicOp from "../../components/topic-op";

const Metadata = <template>
  <TopicOp @topic={{@outletArgs.topic}} />
  <TopicExcerpt @topic={{@outletArgs.topic}} />
  <TopicMetadata @topic={{@outletArgs.topic}} />
</template>;

export default Metadata;
