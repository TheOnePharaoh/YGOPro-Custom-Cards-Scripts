--FNo.39: Anti Utopia
function c125221.initial_effect(c)
    --xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--disable atack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(125221,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c125221.atkcondition)
	e1:SetCost(c125221.atkcost)
	e1:SetOperation(c125221.atkop)
	c:RegisterEffect(e1)
	--xyz summon utopia when destroyed
	local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(125221,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_QUICK_F)
    e2:SetCode(EVENT_DESTROYED)
    e2:SetCountLimit(1)
    e2:SetTarget(c125221.sptg)
    e2:SetOperation(c125221.spop)
    c:RegisterEffect(e2)
end
c125221.xyz_number=39
function c125221.atkcondition(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bt=eg:GetFirst()
    return bt:GetControler()~=c:GetControler()
end
function c125221.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c125221.atkop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateAttack() then
        Duel.Damage(Duel.GetAttacker():GetControler(),Duel.GetAttacker():GetBaseAttack(),REASON_EFFECT)
    end
end
function c125221.filter(c,e,tp)
     return c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and c:IsCode(84013237)
end
function c125221.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_EXTRA+LOCATION_GRAVE) and chkc:IsControler(tp) and c125221.filter(chkc,e,tp) end
	if chk==0 then return e:IsHasType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_QUICK_F) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c125221.filter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c125221.filter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c125221.spop(e,tp,eg,ep,ev,re,r,rp,chk)
local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)~=0 and c:IsRelateToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end