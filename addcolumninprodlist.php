
<?php
/**
 * 2022 Joan Melis
 *
 * NOTICE OF LICENSE
 *
 * This source file is subject to the Academic Free License (AFL 3.0)
 * that is bundled with this package in the file LICENSE.txt.
 * It is also available through the world-wide-web at this URL:
 * http://opensource.org/licenses/afl-3.0.php
 * If you did not receive a copy of the license and are unable to
 * obtain it through the world-wide-web, please send an email
 * to license@prestashop.com so we can send you a copy immediately.
 *
 *  @author    Joan Melis
 *  @copyright 2022 Joan Melis <https://www.joanmelis.com/>
 *  @license   http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
 */

if (!defined('_PS_VERSION_')) {
     exit;
}

class AddColumnInProdList extends Module
{
    public function __construct()
    {
        $this->name = 'addcolumninprodlist';
        $this->author = 'Joan Melis';
        $this->version = '1.0.0';
        $this->need_instance = 0;
        $this->bootstrap = true;
        $this->tab = 'others';
        parent::__construct();

        $this->displayName = $this->l('Add column in product list');
        $this->ps_versions_compliancy = array(
            'min' => '1.7.5',
            'max' => _PS_VERSION_
        );
        $this->description = $this->l(
            'Add column MPN in product list.'
        );
    }

    public function install()
    {
        if (!parent::install()
            || !$this->registerHook('displayAdminCatalogProductHeader')
            || !$this->registerHook('displayAdminCatalogProductFilter')
            || !$this->registerHook('displayAdminCatalogListingProductFields')
            || !$this->registerHook('actionAdminProductsListingFieldsModifier')
        ) {
            return false;
        }
        return true;
    }

    public function hookDisplayAdminCatalogProductHeader($params)
    {
        return $this->display(
            __FILE__,
            'views/templates/hook/product_list_header.tpl'
        );
    }

    public function hookDisplayAdminCatalogProductFilter($params)
    {
        $this->context->smarty->assign([
            'filter_column_mpn' => Tools::getValue('filter_column_mpn', '')
        ]);
        return $this->display(
            __FILE__,
            'views/templates/hook/product_list_filter.tpl'
        );
    }

    public function hookDisplayAdminCatalogListingProductFields($params)
    {
        $this->context->smarty->assign(
            'product', $params['product']
        );
        return $this->display(
            __FILE__,
            'views/templates/hook/product_list_fields.tpl'
        );
    }

    public function hookActionAdminProductsListingFieldsModifier($params)
    {
        $mpn = Tools::getValue('filter_column_mpn', false);

        $params['sql_select']['mpn'] = array(
        'table' => 'p',
        'field' => 'mpn'
    );
        if ($mpn && $mpn !=  '') {            
             $params['sql_where'][] = 'p.mpn '.$mpn;

        }


    }
}
