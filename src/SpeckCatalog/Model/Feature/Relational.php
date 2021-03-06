<?php

namespace SpeckCatalog\Model\Feature;

use SpeckCatalog\Model\AbstractModel;
use SpeckCatalog\Model\Feature as Base;

class Relational extends Base
{
    protected $parent;

    /**
     * @return parent
     */
    public function getParent()
    {
        return $this->parent;
    }

    /**
     * @param $parent
     * @return self
     */
    public function setParent(AbstractModel $parent)
    {
        $this->parent = $parent;
        return $this;
    }
}
