--Cloning Mark
function c112000011.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c112000011.target)
	e1:SetOperation(c112000011.operation)
	c:RegisterEffect(e1)
end
function c112000011.filter1(c,e,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c112000011.filter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,c:GetLevel(),c:GetCode(),c:GetAttack(),e,tp)
end
function c112000011.filter2(c,lv,code,atk,e,tp)
	return c:GetLevel()==lv and c:GetAttack()==atk and c:GetCode()~=code and c:IsType(TYPE_NORMAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c112000011.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c112000011.filter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c112000011.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c112000011.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c112000011.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c112000011.filter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,tc:GetLevel(),tc:GetCode(),tc:GetAttack(),e,tp)
	local sc=g:GetFirst()
	if sc and Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		sc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		sc:RegisterEffect(e2,true)
		Duel.SpecialSummonComplete()
	end
end
