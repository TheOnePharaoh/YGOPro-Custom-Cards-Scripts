--Awakening the Forgotten Memory
function c11111126.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11111126)
	e1:SetCost(c11111126.cost)
	e1:SetTarget(c11111126.target)
	e1:SetOperation(c11111126.activate)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c11111126.atkcon)
	e2:SetCost(c11111126.atkcost)
	e2:SetTarget(c11111126.atktg)
	e2:SetOperation(c11111126.atkop)
	c:RegisterEffect(e2)
end
function c11111126.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCurrentPhase()~=PHASE_MAIN2 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c11111126.mfilter1(c,e)
	return c:IsFaceup() and c:GetLevel()>0 and not c:IsImmuneToEffect(e) and c:IsReleasable()
end
function c11111126.mfilter2(c)
	return c:IsHasEffect(EFFECT_EXTRA_RITUAL_MATERIAL) and c:IsAbleToRemove()
end
function c11111126.get_material(e,tp)
	local g1=Duel.GetMatchingGroup(c11111126.mfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
	local g2=Duel.GetMatchingGroup(c11111126.mfilter2,tp,LOCATION_GRAVE,0,nil)
	g1:Merge(g2)
	return g1
end
function c11111126.filter(c,e,tp,m)
	if bit.band(c:GetType(),0x81)~=0x81 or not c:IsSetCard(0x0dac401)
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false) then return false end
	if m:IsContains(c) then
		m:RemoveCard(c)
		result=m:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
		m:AddCard(c)
	else
		result=m:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
	end
	return result
end
function c11111126.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		local mg=c11111126.get_material(e,tp)
		return Duel.IsExistingMatchingCard(c11111126.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA)
end
function c11111126.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local mg=c11111126.get_material(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c11111126.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp,mg)
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		mg:RemoveCard(tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(tc:GetAttack())
		e1:SetReset(RESET_EVENT+0xfe0000)
		tc:RegisterEffect(e1)
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c11111126.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget()==nil
end
function c11111126.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c11111126.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
end
function c11111126.atkop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	Duel.DisableShuffleCheck()
	if tc:IsSetCard(0x0dac401) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ShuffleHand(tp)
		local at=Duel.GetAttacker()
		if at:IsFaceup() and at:IsRelateToBattle() then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			at:RegisterEffect(e1)
		end
	else
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_REVEAL)
	end
end
