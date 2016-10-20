--Mechquipped Draco
function c19007840.initial_effect(c)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCountLimit(1,19007840)
	e1:SetCondition(c19007840.spcon)
	c:RegisterEffect(e1)
	--shuffle&damage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHANGE_POS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1)
	e2:SetCondition(c19007840.poscon)
	e2:SetTarget(c19007840.damtg)
	e2:SetOperation(c19007840.damop)
	c:RegisterEffect(e2)
end
function c19007840.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xda3791) or c:IsSetCard(0xda3790) or c:IsCode(15914410) or c:IsCode(41309158)
end
function c19007840.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c19007840.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c19007840.poscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(c:GetPreviousPosition(),POS_DEFENSE)~=0 and c:IsFaceup() and c:IsAttackPos() or bit.band(c:GetPreviousPosition(),POS_ATTACK)~=0 and c:IsFaceup() and c:IsDefensePos()
end
function c19007840.dmfilter(c)
	return c:IsLevelBelow(3) and c:IsSetCard(0xda3791) and not c:IsType(TYPE_XYZ) and c:IsAbleToDeck()
end
function c19007840.damtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c19007840.dmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c19007840.dmfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c19007840.dmfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	local atk=g:GetFirst():GetBaseAttack()
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c19007840.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Damage(1-tp,tc:GetBaseAttack(),REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
