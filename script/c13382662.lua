--Accel Vocaloid Nekomura Iroha
function c13382662.initial_effect(c)
	c:SetSPSummonOnce(13382662)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),aux.NonTuner(Card.IsRace,RACE_MACHINE),1)
	c:EnableReviveLimit()
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13382662,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c13382662.atkcon)
	e1:SetOperation(c13382662.atkop)
	c:RegisterEffect(e1)
	--nontuner
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_NONTUNER)
	c:RegisterEffect(e2)
	--synchro custom
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetTarget(c13382662.syntg)
	e3:SetValue(1)
	e3:SetOperation(c13382662.synop)
	c:RegisterEffect(e3)
	--excavate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(13382662,1))
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetCountLimit(1,13382662)
	e4:SetCondition(c13382662.excon)
	e4:SetTarget(c13382662.extg)
	e4:SetOperation(c13382662.exop)
	c:RegisterEffect(e4)
end
function c13382662.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c13382662.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c13382662.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c13382662.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(800)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
c13382662.tuner_filter=aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE)
function c13382661.synfilter(c,syncard,tuner,f)
	return c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard,tuner) and c:IsRace(RACE_MACHINE) and (f==nil or f(c))
end
function c13382662.syntg(e,syncard,f,minc,maxc)
	local c=e:GetHandler()
	local lv=syncard:GetLevel()-c:GetLevel()
	if lv<=0 then return false end
	local g=Duel.GetMatchingGroup(c13382662.synfilter,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	local res=g:CheckWithSumEqual(Card.GetSynchroLevel,lv,minc,maxc,syncard)
	return res
end
function c13382662.synop(e,tp,eg,ep,ev,re,r,rp,syncard,f,minc,maxc)
	local c=e:GetHandler()
	local lv=syncard:GetLevel()-c:GetLevel()
	local g=Duel.GetMatchingGroup(c13382662.synfilter,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local sg=g:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv,minc,maxc,syncard)
	Duel.SetSynchroMaterial(sg)
end
function c13382662.excon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c13382662.extg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c13382662.exfilter(c)
	return c:IsSetCard(0x0dac405) or c:IsSetCard(0x0dac406) and c:IsAbleToHand()
end
function c13382662.exop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	local dc=Duel.TossDice(tp,1)
	Duel.ConfirmDecktop(tp,dc)
	local dg=Duel.GetDecktopGroup(tp,dc)
	local g=dg:Filter(c13382662.exfilter,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
	Duel.ShuffleDeck(tp)
end