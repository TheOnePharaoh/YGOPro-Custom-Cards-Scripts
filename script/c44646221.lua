--Vocaloid Nekomura Iroha/Modified
function c44646221.initial_effect(c)
	c:EnableReviveLimit()
	--Cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--destroy and recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(44646221,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c44646221.target)
	e2:SetOperation(c44646221.operation)
	c:RegisterEffect(e2)
	--spson
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(aux.FALSE)
	c:RegisterEffect(e3)
end
function c44646221.filter(c)
	return c:IsFacedown() and c:IsDestructable()
end
function c44646221.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_ONFIELD) and c44646221.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c44646221.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c44646221.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,1000)
end
function c44646221.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFacedown() and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		Duel.Recover(1-tp,1000,REASON_EFFECT)
	end
end
