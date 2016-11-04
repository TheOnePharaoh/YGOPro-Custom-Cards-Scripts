--Corridor of the Dragonsbane - Eternal Synthesis
function c66660015.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--active limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c66660015.actcon)
	e2:SetOperation(c66660015.actop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetDescription(aux.Stringid(66660015,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTarget(c66660015.target)
	e3:SetOperation(c66660015.operation)
	c:RegisterEffect(e3)
		--search
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,66660015)
	e4:SetCost(c66660015.thcost)
	e4:SetTarget(c66660015.thtg)
	e4:SetOperation(c66660015.thop)
	c:RegisterEffect(e4)
end
function c66660015.actcon(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetAttacker()
	return ac and ac:IsControler(tp) and ac:IsRace(RACE_PLANT)
end
function c66660015.actop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c66660015.actlimit)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
	c:RegisterEffect(e1)
end
function c66660015.accon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLP(tp)>Duel.GetLP(1-tp)
end
function c66660015.actlimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c66660015.pfilter(c,rc)
	return c:IsCanBeRitualMaterial(rc)
end
function c66660015.filter(c,e,tp,m)
	if not (c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_DRAGON)) or bit.band(c:GetType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m:Filter(c66660015.pfilter,c,c)
	return mg:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel(),c)
end
function c66660015.exfilter0(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and (c:IsRace(RACE_FIEND) or c:IsRace(RACE_DRAGON))
		and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c66660015.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 then
			local sg=Duel.GetMatchingGroup(c66660015.exfilter0,tp,LOCATION_GRAVE,0,nil)
			mg:Merge(sg)
		end
		return Duel.IsExistingMatchingCard(c66660015.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c66660015.operation(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 then
		local sg=Duel.GetMatchingGroup(c66660015.exfilter0,tp,LOCATION_GRAVE,0,nil)
		mg:Merge(sg)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c66660015.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg)
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		mg:RemoveCard(tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetOriginalLevel(),tc)
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c66660015.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK)  and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c66660015.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c66660015.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c66660015.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c66660015.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_DRAGON) and c:IsType(TYPE_MONSTER) and  c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c66660015.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c66660015.thop(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c66660015.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,e:GetLabel())
	if g:GetCount()==0 then return end
	local tc=g:GetFirst()
	if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_CANNOT_ATTACK)
		e0:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e0,true)
			Duel.SpecialSummonComplete()
	end
	end