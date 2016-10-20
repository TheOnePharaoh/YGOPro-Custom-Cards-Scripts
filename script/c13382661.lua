--Vocaloid Nekomura Iroha
function c13382661.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c13382661.spcon)
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
	e3:SetTarget(c13382661.syntg)
	e3:SetValue(1)
	e3:SetOperation(c13382661.synop)
	c:RegisterEffect(e3)
	--salvage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(13382661,0))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetCountLimit(1,13382661)
	e4:SetCondition(c13382661.thcon)
	e4:SetTarget(c13382661.thtg)
	e4:SetOperation(c13382661.thop)
	c:RegisterEffect(e4)
end
function c13382661.specfilter(c)
	return c:IsFacedown() or c:IsCode(13382661) or not c:IsRace(RACE_MACHINE)
end
function c13382661.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)>0
		and not	Duel.IsExistingMatchingCard(c13382661.specfilter,tp,LOCATION_MZONE,0,1,nil)
end
c13382661.tuner_filter=aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE)
function c13382661.synfilter(c,syncard,tuner,f)
	return c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard,tuner) and c:IsRace(RACE_MACHINE) and (f==nil or f(c))
end
function c13382661.syntg(e,syncard,f,minc,maxc)
	local c=e:GetHandler()
	local lv=syncard:GetLevel()-c:GetLevel()
	if lv<=0 then return false end
	local g=Duel.GetMatchingGroup(c13382661.synfilter,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	local res=g:CheckWithSumEqual(Card.GetSynchroLevel,lv,minc,maxc,syncard)
	return res
end
function c13382661.synop(e,tp,eg,ep,ev,re,r,rp,syncard,f,minc,maxc)
	local c=e:GetHandler()
	local lv=syncard:GetLevel()-c:GetLevel()
	local g=Duel.GetMatchingGroup(c13382661.synfilter,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local sg=g:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv,minc,maxc,syncard)
	Duel.SetSynchroMaterial(sg)
end
function c13382661.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
		and c:GetReasonCard():IsSetCard(0x0dac402)
end
function c13382661.thfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x0dac406) and c:IsAbleToHand()
end
function c13382661.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c13382661.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c13382661.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c13382661.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c13382661.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
