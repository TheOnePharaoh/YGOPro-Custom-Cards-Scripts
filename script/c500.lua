--Spatial Procedure
function c500.initial_effect(c)
	if not c500.global_check then
		c500.global_check=true
		--register
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_ADJUST)
		e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e0:SetOperation(c500.op)
		Duel.RegisterEffect(e0,0)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		e1:SetTargetRange(0xef,0)
		e1:SetTarget(function(e,c) return c.spatial end)
		e1:SetValue(LOCATION_REMOVED)
		Duel.RegisterEffect(e1,0)
	end
end
function c500.regfilter(c)
	return c.spatial
end
function c500.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c500.regfilter,0,LOCATION_DECK+LOCATION_EXTRA,LOCATION_DECK+LOCATION_EXTRA,nil)
	local tc=g:GetFirst()
	local n=1
	while tc do
		if tc:IsLocation(LOCATION_DECK) then Duel.DisableShuffleCheck() Duel.SendtoHand(tc,nil,REASON_RULE) end
		if tc:GetFlagEffect(500)==0 then
			tc:EnableReviveLimit()
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_SPSUMMON_PROC)
			e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
			e1:SetRange(LOCATION_EXTRA)
			e1:SetCondition(c500.sptcon)
			e1:SetOperation(c500.sptop)
			e1:SetValue(0x7150)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(tc)
			e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e2:SetCode(EVENT_SPSUMMON_SUCCESS)
			e2:SetCondition(function(e) return bit.band(e:GetHandler():GetSummonType(),0x7150)==0x7150 end)
			e2:SetOperation(function(e) e:GetHandler():CompleteProcedure() end)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(tc)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e3:SetCode(EFFECT_REMOVE_TYPE)
			e3:SetValue(TYPE_XYZ)
			tc:RegisterEffect(e3)
			local e4=Effect.CreateEffect(tc)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
			e4:SetValue(1)
			tc:RegisterEffect(e4)
			n=1
			if tc:GetRank()>4 then n=n+1 end
			if tc:GetRank()>6 then n=n+1 end
			if tc:GetRank()>9 and tc:IsAttribute(ATTRIBUTE_DEVINE) and tc:IsRace(RACE_DEVINE) then n=n+1 end
			if tc.dimension_loss and not tc:IsDisabled() then n=tc.dimension_loss end
			local e5=Effect.CreateEffect(tc)
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
			e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_NO_TURN_RESET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e5:SetRange(LOCATION_MZONE)
			e5:SetCountLimit(n)
			e5:SetValue(c500.valcon)
			tc:RegisterEffect(e5)
			tc:RegisterFlagEffect(500,0,0,1)
		end
		tc=g:GetNext()
	end
end
function c500.sptfilter1(c,tp,djn,f)
	return c:IsFaceup() and c:GetLevel()>0 and (not f or f(c)) and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c500.sptfilter2,tp,LOCATION_MZONE,0,1,c,djn,f,c:GetAttribute(),c:GetRace(),c:GetLevel())
end
function c500.sptafilter(c,alterf)
	return c:IsFaceup() and alterf(c) and c:IsAbleToRemoveAsCost()
end
function c500.sptfilter2(c,djn,f,at,rc,lv)
	return c:IsFaceup() and c:GetAttribute()==at and c:GetRace()==rc
		and c:GetLevel()>0 and (djn==lv or djn==c:GetLevel())
		and (not f or f(c)) and c:IsAbleToRemoveAsCost()
end
function c500.sptcon(e,c)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<-2 then return end
	if c.alterf and Duel.IsExistingMatchingCard(c500.sptafilter,tp,LOCATION_MZONE,0,1,nil,c.alterf)
		and (not c.alterop or c.alterop(e,tp,0)) then
		return true
	end
	return Duel.IsExistingMatchingCard(c500.sptfilter1,tp,LOCATION_MZONE,0,1,nil,tp,c:GetRank(),c.material)
end
function c500.sptop(e,tp,eg,ep,ev,re,r,rp,c)
	local x=c:GetRank()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local m1=Duel.SelectMatchingCard(tp,c500.sptfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp,x,c.material)
	local tc=m1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local m2=Duel.SelectMatchingCard(tp,c500.sptfilter2,tp,LOCATION_MZONE,0,1,1,tc,x,c.material,tc:GetAttribute(),tc:GetRace(),tc:GetLevel())
	m1:Merge(m2)
	c:SetMaterial(m1)
	Duel.Remove(m1,POS_FACEUP,REASON_MATERIAL+0x71500000000)
end
function c500.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
