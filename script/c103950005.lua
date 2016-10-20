--Possessed Shadow
function c103950005.initial_effect(c)

	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(103950005,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c103950005.target)
	e1:SetOperation(c103950005.operation)
	c:RegisterEffect(e1)
end

--Special Summon filter
function c103950005.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and
		c:GetLocation()==LOCATION_GRAVE and
		c:GetControler()==tp
end
--Negation filter
function c103950005.negfilter(c,tp)
	return c:GetControler()~=tp and
		c:GetLocation()==LOCATION_MZONE and
		c:IsType(TYPE_MONSTER) and
		c:IsFaceup()
end
--Activate target
function c103950005.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return true end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c103950005.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.IsExistingTarget(c103950005.negfilter,tp,0,LOCATION_MZONE,1,nil,tp) end
		
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,c103950005.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(103950005,2))
	local g2=Duel.SelectTarget(tp,c103950005.negfilter,tp,0,LOCATION_MZONE,1,1,nil)
	
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g2,1,0,0)
end
--Activate operation
function c103950005.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc1,tc2=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and
		tc1:IsRelateToEffect(e) and
		c103950005.spfilter(tc1,e,tp) and
		tc2:IsRelateToEffect(e) and
		c103950005.negfilter(tc2)
		then
		
		if Duel.SpecialSummon(tc1,0,tp,tp,false,false,POS_FACEUP_ATTACK)==0 then return end
		
		--Alter ATK and DEF
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc1:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_BASE_DEFENSE)
		e2:SetValue(0)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc1:RegisterEffect(e2,true)
		
		--Steal name and effect
		local code=tc2:GetOriginalCode()
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetCode(EFFECT_CHANGE_CODE)
		e3:SetValue(code)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc1:RegisterEffect(e3)
		tc1:CopyEffect(code,RESET_EVENT+0x1fe0000,1)
		
		c:SetCardTarget(tc1)
		c:SetCardTarget(tc2)
		
		--Negate summoned effect
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_OWNER_RELATE)
		e4:SetCode(EFFECT_DISABLE)
		e4:SetRange(LOCATION_MZONE)
		e4:SetCondition(c103950005.negsummonedcon)
		e4:SetReset(RESET_EVENT+0x1fe0000)
		tc1:RegisterEffect(e4,true)
		
		--Negate other effect
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_OWNER_RELATE)
		e5:SetCode(EFFECT_DISABLE)
		e5:SetRange(LOCATION_MZONE)
		e5:SetCondition(c103950005.negothercon)
		e5:SetReset(RESET_EVENT+0x1fe0000)
		tc2:RegisterEffect(e5,true)
		
		--Destroy summoned
		tc1:RegisterFlagEffect(103950005,RESET_EVENT+0x1fe0000,0,1)
		
		local e6=Effect.CreateEffect(c)
		e6:SetDescription(aux.Stringid(103950005,1))
		e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
		e6:SetCode(EVENT_LEAVE_FIELD)
		e6:SetLabelObject(tc1)
		e6:SetOperation(c103950005.desop)
		c:RegisterEffect(e6)
	end
end
--Negate summoned monster effect condition
function c103950005.negsummonedcon(e)
	return (e:GetOwner():GetCardTargetCount() == 1) and e:GetOwner():IsHasCardTarget(e:GetHandler())
end
--Negate other monster's effect condition
function c103950005.negothercon(e)
	return (e:GetOwner():GetCardTargetCount() == 2) and e:GetOwner():IsHasCardTarget(e:GetHandler())
end

--Destruction operation
function c103950005.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc and tc:GetFlagEffect(103950005)>0 then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
