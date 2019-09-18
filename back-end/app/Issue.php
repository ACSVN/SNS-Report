<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Issue extends Model
{
    protected $fillable = ['common_report_id', 'report_template_id', 'parameters'];

	public function report()
	{
		return $this->hasOne('App\Report');
	}

	public function AgencyTemplate()
	{
		return $this->belongsTo('App\ReportTemplate');
	}

	public function reportTemplate()
	{
		return $this->belongsTo('App\ReportTemplate');
	}
}
