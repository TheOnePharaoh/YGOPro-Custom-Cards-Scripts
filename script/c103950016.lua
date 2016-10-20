--Tune Master
function c103950016.initial_effect(c)

	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(103950016,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c103950016.spcon)
	e1:SetTarget(c103950016.sptg)
	e1:SetOperation(c103950016.spop)
	c:RegisterEffect(e1)
	
	--Gain ATK
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(103950016,1))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c103950016.atktgt)
	e2:SetOperation(c103950016.atkop)
	c:RegisterEffect(e2)
end

--Special Summon check
function c103950016.spcheck(tp)
	local ret=false
	for i=0,4 do
		local tc=Duel.GetFieldCard(tp,LOCATION_MZONE,i)
		if tc then
			if not ret and tc:IsFaceup() and tc:IsType(TYPE_TUNER) then
				ret=true
			else
				return false
			end
		end
	end
	return ret
end

--Special Summon condition
function c103950016.spcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetFlagEffect(tp,103950016)==0 and c103950016.spcheck(tp)
end

--Special Summon target
function c103950016.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) end
	Duel.RegisterFlagEffect(tp,103950016,0,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

--Special Summon operation
function c103950016.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not c103950016.spcheck(tp) then return end
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
	
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+0xff0000)
		e1:SetCode(EFFECT_REMOVE_TYPE)
		e1:SetValue(TYPE_TUNER)
		c:RegisterEffect(e1,true)
	end
end


--Gain ATK filter
function c103950016.atkfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsType(TYPE_TUNER)
end

--Gain ATK target
function c103950016.atktgt(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c103950016.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c103950016.atkfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c103950016.atkfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
end

--Gain ATK operation
function c103950016.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c103950016.atkfilter(tc) and tc:IsRelateToEffect(e) then
		
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_REMOVE_TYPE)
		e1:SetValue(TYPE_TUNER)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(500)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e2)
	end
end