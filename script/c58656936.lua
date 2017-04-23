--No. 90 Vocaloid Alternation Accel Gauntlet
function c58656936.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x0dac402),9,2)
	c:EnableReviveLimit()
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.xyzlimit)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(58656936,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetProperty(0,EFFECT_FLAG2_XMDETACH)
	e2:SetCondition(c58656936.atkcon)
	e2:SetCost(c58656936.atkcost)
	e2:SetOperation(c58656936.atkop)
	c:RegisterEffect(e2)
	--handes
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(58656936,1))
	e3:SetCategory(CATEGORY_HANDES+CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c58656936.con)
	e3:SetCost(c58656936.hdcost)
	e3:SetTarget(c58656936.hdtg)
	e3:SetOperation(c58656936.hdop)
	c:RegisterEffect(e3)
	--synchro summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(58656936,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c58656936.syncon)
	e4:SetTarget(c58656936.syntg)
	e4:SetOperation(c58656936.synop)
	c:RegisterEffect(e4)
	--add setcode
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EFFECT_ADD_SETCODE)
	e5:SetValue(0x48)
	c:RegisterEffect(e5)
end
c58656936.xyz_number=90
function c58656936.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsFaceup() and not bc:IsRace(RACE_MACHINE)
end
function c58656936.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c58656936.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local ct=Duel.GetMatchingGroupCount(c58656936.atkfilter,tp,LOCATION_MZONE,0,nil)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ct*400)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_DAMAGE)
		c:RegisterEffect(e1)
	end
end
function c58656936.atkfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_SYNCHRO)
end
function c58656936.confilter(c)
	return c:IsFaceup() and not c:IsRace(RACE_MACHINE)
end
function c58656936.damfilter(c)
	return not c:IsRace(RACE_MACHINE)
end
function c58656936.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c58656936.confilter,tp,0,LOCATION_MZONE,1,nil)
end
function c58656936.hdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	Duel.SendtoGrave(g,REASON_COST)
end
function c58656936.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,1-tp,LOCATION_HAND)
end
function c58656936.hdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	Duel.ConfirmCards(tp,g)
	local sg=g:Filter(c58656936.damfilter,nil)
	if sg:GetCount()>0 then
		local atk=0
		Duel.SendtoGrave(sg,REASON_EFFECT)
		local tc=sg:GetFirst()
		while tc do
			local tatk=tc:GetAttack()
			if tatk<0 then tatk=0 end
			atk=atk+tatk
			tc=sg:GetNext()
		end
		Duel.BreakEffect()
		Duel.Damage(1-tp,atk,REASON_EFFECT)
	end
	Duel.ShuffleHand(1-tp)
end
function c58656936.syncon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY) and e:GetHandler():GetReasonPlayer()~=tp
		and e:GetHandler():GetPreviousControler()==tp
end
function c58656936.rmfilter1(c,e,tp)
	return c:IsRace(RACE_MACHINE) and c:IsSetCard(0x0dac405) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToRemove()
		and Duel.IsExistingMatchingCard(c58656936.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetOriginalLevel())
end
function c58656936.rmfilter2(c,lv)
	return c:IsRace(RACE_MACHINE) and c:IsSetCard(0x0dac405) and c:IsType(TYPE_TUNER) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToRemove() and c:GetOriginalLevel()==lv
end
function c58656936.spfilter(c,e,tp,lv)
	return c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
		and Duel.IsExistingMatchingCard(c58656936.rmfilter2,tp,LOCATION_HAND,0,1,nil,c:GetLevel()-lv)
end
function c58656936.syntg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c58656936.rmfilter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c58656936.rmfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c58656936.rmfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c58656936.synop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c58656936.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetOriginalLevel())
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=Duel.SelectMatchingCard(tp,c58656936.rmfilter2,tp,LOCATION_HAND,0,1,1,nil,g:GetFirst():GetLevel()-tc:GetOriginalLevel())
		rg:AddCard(tc)
		if Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)==2 then
			Duel.SpecialSummon(g,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		end
	end
end