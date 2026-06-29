// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'task_model.dart';

class TaskListResponseModelMapper
    extends ClassMapperBase<TaskListResponseModel> {
  TaskListResponseModelMapper._();

  static TaskListResponseModelMapper? _instance;
  static TaskListResponseModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TaskListResponseModelMapper._());
      TaskModelMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'TaskListResponseModel';

  static List<TaskModel> _$data(TaskListResponseModel v) => v.data;
  static const Field<TaskListResponseModel, List<TaskModel>> _f$data =
      Field('data', _$data);

  @override
  final MappableFields<TaskListResponseModel> fields = const {
    #data: _f$data,
  };

  static TaskListResponseModel _instantiate(DecodingData data) {
    return TaskListResponseModel(data: data.dec(_f$data));
  }

  @override
  final Function instantiate = _instantiate;

  static TaskListResponseModel fromJson(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TaskListResponseModel>(map);
  }

  static TaskListResponseModel fromJsonString(String json) {
    return ensureInitialized().decodeJson<TaskListResponseModel>(json);
  }
}

mixin TaskListResponseModelMappable {}

class TaskModelMapper extends ClassMapperBase<TaskModel> {
  TaskModelMapper._();

  static TaskModelMapper? _instance;
  static TaskModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TaskModelMapper._());
      TaskIssueModelMapper.ensureInitialized();
      TaskMediaModelMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'TaskModel';

  static int _$id(TaskModel v) => v.id;
  static const Field<TaskModel, int> _f$id = Field('id', _$id);
  static String _$title(TaskModel v) => v.title;
  static const Field<TaskModel, String> _f$title = Field('title', _$title);
  static String? _$description(TaskModel v) => v.description;
  static const Field<TaskModel, String> _f$description =
      Field('description', _$description, opt: true);
  static String? _$facilityName(TaskModel v) => v.facilityName;
  static const Field<TaskModel, String> _f$facilityName =
      Field('facilityName', _$facilityName, key: r'facility_name', opt: true);
  static String? _$dueAt(TaskModel v) => v.dueAt;
  static const Field<TaskModel, String> _f$dueAt =
      Field('dueAt', _$dueAt, key: r'due_at', opt: true);
  static String _$status(TaskModel v) => v.status;
  static const Field<TaskModel, String> _f$status = Field('status', _$status);
  static String _$priority(TaskModel v) => v.priority;
  static const Field<TaskModel, String> _f$priority =
      Field('priority', _$priority);
  static TaskIssueModel? _$issue(TaskModel v) => v.issue;
  static const Field<TaskModel, TaskIssueModel> _f$issue =
      Field('issue', _$issue, opt: true);
  static List<TaskMediaModel>? _$media(TaskModel v) => v.media;
  static const Field<TaskModel, List<TaskMediaModel>> _f$media =
      Field('media', _$media, opt: true);

  @override
  final MappableFields<TaskModel> fields = const {
    #id: _f$id,
    #title: _f$title,
    #description: _f$description,
    #facilityName: _f$facilityName,
    #dueAt: _f$dueAt,
    #status: _f$status,
    #priority: _f$priority,
    #issue: _f$issue,
    #media: _f$media,
  };

  static TaskModel _instantiate(DecodingData data) {
    return TaskModel(
        id: data.dec(_f$id),
        title: data.dec(_f$title),
        description: data.dec(_f$description),
        facilityName: data.dec(_f$facilityName),
        dueAt: data.dec(_f$dueAt),
        status: data.dec(_f$status),
        priority: data.dec(_f$priority),
        issue: data.dec(_f$issue),
        media: data.dec(_f$media));
  }

  @override
  final Function instantiate = _instantiate;

  static TaskModel fromJson(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TaskModel>(map);
  }

  static TaskModel fromJsonString(String json) {
    return ensureInitialized().decodeJson<TaskModel>(json);
  }
}

mixin TaskModelMappable {}

class TaskIssueModelMapper extends ClassMapperBase<TaskIssueModel> {
  TaskIssueModelMapper._();

  static TaskIssueModelMapper? _instance;
  static TaskIssueModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TaskIssueModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'TaskIssueModel';

  static String? _$problemCategoryName(TaskIssueModel v) =>
      v.problemCategoryName;
  static const Field<TaskIssueModel, String> _f$problemCategoryName = Field(
      'problemCategoryName', _$problemCategoryName,
      key: r'problem_category_name', opt: true);
  static bool _$proofRequiredOnComplete(TaskIssueModel v) =>
      v.proofRequiredOnComplete;
  static const Field<TaskIssueModel, bool> _f$proofRequiredOnComplete = Field(
      'proofRequiredOnComplete', _$proofRequiredOnComplete,
      key: r'proof_required_on_complete', opt: true, def: false);

  @override
  final MappableFields<TaskIssueModel> fields = const {
    #problemCategoryName: _f$problemCategoryName,
    #proofRequiredOnComplete: _f$proofRequiredOnComplete,
  };

  static TaskIssueModel _instantiate(DecodingData data) {
    return TaskIssueModel(
        problemCategoryName: data.dec(_f$problemCategoryName),
        proofRequiredOnComplete: data.dec(_f$proofRequiredOnComplete));
  }

  @override
  final Function instantiate = _instantiate;

  static TaskIssueModel fromJson(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TaskIssueModel>(map);
  }

  static TaskIssueModel fromJsonString(String json) {
    return ensureInitialized().decodeJson<TaskIssueModel>(json);
  }
}

mixin TaskIssueModelMappable {}

class TaskMediaModelMapper extends ClassMapperBase<TaskMediaModel> {
  TaskMediaModelMapper._();

  static TaskMediaModelMapper? _instance;
  static TaskMediaModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TaskMediaModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'TaskMediaModel';

  static int _$id(TaskMediaModel v) => v.id;
  static const Field<TaskMediaModel, int> _f$id = Field('id', _$id);
  static String _$url(TaskMediaModel v) => v.url;
  static const Field<TaskMediaModel, String> _f$url = Field('url', _$url);
  static String? _$alt(TaskMediaModel v) => v.alt;
  static const Field<TaskMediaModel, String> _f$alt =
      Field('alt', _$alt, opt: true);

  @override
  final MappableFields<TaskMediaModel> fields = const {
    #id: _f$id,
    #url: _f$url,
    #alt: _f$alt,
  };

  static TaskMediaModel _instantiate(DecodingData data) {
    return TaskMediaModel(
        id: data.dec(_f$id), url: data.dec(_f$url), alt: data.dec(_f$alt));
  }

  @override
  final Function instantiate = _instantiate;

  static TaskMediaModel fromJson(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TaskMediaModel>(map);
  }

  static TaskMediaModel fromJsonString(String json) {
    return ensureInitialized().decodeJson<TaskMediaModel>(json);
  }
}

mixin TaskMediaModelMappable {}

class TaskDetailResponseModelMapper
    extends ClassMapperBase<TaskDetailResponseModel> {
  TaskDetailResponseModelMapper._();

  static TaskDetailResponseModelMapper? _instance;
  static TaskDetailResponseModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = TaskDetailResponseModelMapper._());
      TaskDetailModelMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'TaskDetailResponseModel';

  static TaskDetailModel _$data(TaskDetailResponseModel v) => v.data;
  static const Field<TaskDetailResponseModel, TaskDetailModel> _f$data =
      Field('data', _$data);

  @override
  final MappableFields<TaskDetailResponseModel> fields = const {
    #data: _f$data,
  };

  static TaskDetailResponseModel _instantiate(DecodingData data) {
    return TaskDetailResponseModel(data: data.dec(_f$data));
  }

  @override
  final Function instantiate = _instantiate;

  static TaskDetailResponseModel fromJson(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TaskDetailResponseModel>(map);
  }

  static TaskDetailResponseModel fromJsonString(String json) {
    return ensureInitialized().decodeJson<TaskDetailResponseModel>(json);
  }
}

mixin TaskDetailResponseModelMappable {}

class TaskDetailModelMapper extends ClassMapperBase<TaskDetailModel> {
  TaskDetailModelMapper._();

  static TaskDetailModelMapper? _instance;
  static TaskDetailModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TaskDetailModelMapper._());
      TaskIssueModelMapper.ensureInitialized();
      TaskMediaModelMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'TaskDetailModel';

  static int _$id(TaskDetailModel v) => v.id;
  static const Field<TaskDetailModel, int> _f$id = Field('id', _$id);
  static String _$title(TaskDetailModel v) => v.title;
  static const Field<TaskDetailModel, String> _f$title =
      Field('title', _$title);
  static String? _$description(TaskDetailModel v) => v.description;
  static const Field<TaskDetailModel, String> _f$description =
      Field('description', _$description, opt: true);
  static String? _$facilityName(TaskDetailModel v) => v.facilityName;
  static const Field<TaskDetailModel, String> _f$facilityName =
      Field('facilityName', _$facilityName, key: r'facility_name', opt: true);
  static String? _$dueAt(TaskDetailModel v) => v.dueAt;
  static const Field<TaskDetailModel, String> _f$dueAt =
      Field('dueAt', _$dueAt, key: r'due_at', opt: true);
  static String _$status(TaskDetailModel v) => v.status;
  static const Field<TaskDetailModel, String> _f$status =
      Field('status', _$status);
  static String _$priority(TaskDetailModel v) => v.priority;
  static const Field<TaskDetailModel, String> _f$priority =
      Field('priority', _$priority);
  static bool _$proofRequiredOnComplete(TaskDetailModel v) =>
      v.proofRequiredOnComplete;
  static const Field<TaskDetailModel, bool> _f$proofRequiredOnComplete = Field(
      'proofRequiredOnComplete', _$proofRequiredOnComplete,
      key: r'proof_required_on_complete', opt: true, def: false);
  static TaskIssueModel? _$issue(TaskDetailModel v) => v.issue;
  static const Field<TaskDetailModel, TaskIssueModel> _f$issue =
      Field('issue', _$issue, opt: true);
  static List<TaskMediaModel>? _$media(TaskDetailModel v) => v.media;
  static const Field<TaskDetailModel, List<TaskMediaModel>> _f$media =
      Field('media', _$media, opt: true);

  @override
  final MappableFields<TaskDetailModel> fields = const {
    #id: _f$id,
    #title: _f$title,
    #description: _f$description,
    #facilityName: _f$facilityName,
    #dueAt: _f$dueAt,
    #status: _f$status,
    #priority: _f$priority,
    #proofRequiredOnComplete: _f$proofRequiredOnComplete,
    #issue: _f$issue,
    #media: _f$media,
  };

  static TaskDetailModel _instantiate(DecodingData data) {
    return TaskDetailModel(
        id: data.dec(_f$id),
        title: data.dec(_f$title),
        description: data.dec(_f$description),
        facilityName: data.dec(_f$facilityName),
        dueAt: data.dec(_f$dueAt),
        status: data.dec(_f$status),
        priority: data.dec(_f$priority),
        proofRequiredOnComplete: data.dec(_f$proofRequiredOnComplete),
        issue: data.dec(_f$issue),
        media: data.dec(_f$media));
  }

  @override
  final Function instantiate = _instantiate;

  static TaskDetailModel fromJson(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TaskDetailModel>(map);
  }

  static TaskDetailModel fromJsonString(String json) {
    return ensureInitialized().decodeJson<TaskDetailModel>(json);
  }
}

mixin TaskDetailModelMappable {}

class TaskMediaResponseModelMapper
    extends ClassMapperBase<TaskMediaResponseModel> {
  TaskMediaResponseModelMapper._();

  static TaskMediaResponseModelMapper? _instance;
  static TaskMediaResponseModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TaskMediaResponseModelMapper._());
      TaskMediaModelMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'TaskMediaResponseModel';

  static TaskMediaModel _$data(TaskMediaResponseModel v) => v.data;
  static const Field<TaskMediaResponseModel, TaskMediaModel> _f$data =
      Field('data', _$data);

  @override
  final MappableFields<TaskMediaResponseModel> fields = const {
    #data: _f$data,
  };

  static TaskMediaResponseModel _instantiate(DecodingData data) {
    return TaskMediaResponseModel(data: data.dec(_f$data));
  }

  @override
  final Function instantiate = _instantiate;

  static TaskMediaResponseModel fromJson(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TaskMediaResponseModel>(map);
  }

  static TaskMediaResponseModel fromJsonString(String json) {
    return ensureInitialized().decodeJson<TaskMediaResponseModel>(json);
  }
}

mixin TaskMediaResponseModelMappable {}
