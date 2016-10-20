--Accel Vocaloid Sachiko Nadeshiko
function c77662925.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c77662925.regcon)
	e1:SetOperation(c77662925.regop)
	c:RegisterEffect(e1)
	--lv
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77662925,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c77662925.tgcost)
	e2:SetTarget(c77662925.tgtg)
	e2:SetOperation(c77662925.tgop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77662925,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,0x1c0+TIMING_MAIN_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c77662925.spcon)
	e3:SetTarget(c77662925.sptg)
	e3:SetOperation(c77662925.spop)
	c:RegisterEffect(e3)
	--battle indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e4:SetCountLimit(1)
	e4:SetValue(c77662925.valcon)
	c:RegisterEffect(e4)
	--nontuner
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_NONTUNER)
	e5:SetCondition(c77662925.cscon)
	c:RegisterEffect(e5)
end
function c77662925.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c77662925.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c77662925.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c77662925.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(77662925) and bit.band(sumtype,SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO
end
function c77662925.filter(c)
	return c:GetLevel()>0 and c:IsSetCard(0x0dac405) and c:IsType(TYPE_TUNER) and c:IsAbleToGraveAsCost()
end
function c77662925.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77662925.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c77662925.filter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabelObject(g:GetFirst())
end
function c77662925.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local opt=Duel.SelectOption(tp,aux.Stringid(77662925,2),aux.Stringid(77662925,3))
	e:SetLabel(opt)
end
function c77662925.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lv=e:GetLabelObject():GetLevel()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		if e:GetLabel()==0 then
			e1:SetValue(lv)
		else
			e1:SetValue(-lv)
		end
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
end
function c77662925.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c77662925.scfilter(c)
	return c:IsSetCard(0x0dac402) and c:IsSynchroSummonable(nil)
end
function c77662925.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING)
		and Duel.IsExistingMatchingCard(c77662925.scfilter,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c77662925.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsControler(1-tp) or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c77662925.scfilter,tp,LOCATION_EXTRA,0,nil,c)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),c)
	end
end
function c77662925.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
function c77662925.csfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE)
end
function c77662925.cscon(e)
	return Duel.IsExistingMatchingCard(c77662925.csfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
