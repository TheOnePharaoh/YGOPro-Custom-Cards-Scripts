--Accel Vocaloid Ring Suzune
function c22874079.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x0dac405),aux.NonTuner(Card.IsRace,RACE_MACHINE),1)
	c:EnableReviveLimit()
	--synchro summon success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22874079,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c22874079.drcon)
	e1:SetTarget(c22874079.drtarg)
	e1:SetOperation(c22874079.drop)
	c:RegisterEffect(e1)
	--lv adjust
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c22874079.lvtg)
	e2:SetOperation(c22874079.lvop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22874079,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c22874079.con)
	e3:SetTarget(c22874079.tg)
	e3:SetOperation(c22874079.op)
	c:RegisterEffect(e3)
	--nontuner
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_NONTUNER)
	e4:SetCondition(c22874079.cscon)
	c:RegisterEffect(e4)
end
function c22874079.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c22874079.drtarg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c22874079.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if Duel.Draw(p,2,REASON_EFFECT)==2 then
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end
function c22874079.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x0dac402) and c:IsType(TYPE_SYNCHRO) and not c:IsCode(22874079) and c:GetLevel()>0
end
function c22874079.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c22874079.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22874079.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c22874079.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local t={}
	local i=1
	local p=1
	local lv=g:GetFirst():GetLevel()
	for i=1,8 do
		if lv~=i then t[p]=i p=p+1 end
	end
	t[p]=nil
	Duel.Hint(HINT_SELECTMSG,tp,567)
	e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t)))
end
function c22874079.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c22874079.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c22874079.splimit(e,c)
	return not c:IsRace(RACE_MACHINE)
end
function c22874079.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c22874079.specfilter(c,e,tp)
	return c:IsType(TYPE_TUNER) and c:IsSetCard(0x0dac405) and c:IsLevelBelow(2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22874079.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c22874079.specfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c22874079.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22874079.specfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c22874079.csfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x0dac402) and c:IsType(TYPE_SYNCHRO)
end
function c22874079.cscon(e)
	return Duel.IsExistingMatchingCard(c22874079.csfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end