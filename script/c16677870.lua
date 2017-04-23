--Do Re Mi Fa
function c16677870.initial_effect(c)
	c:SetUniqueOnField(1,0,16677870)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c16677870.atkval)
	e2:SetCondition(c16677870.atkcon)
	e2:SetTarget(c16677870.atktg)
	c:RegisterEffect(e2)
	--damage&draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(16677870,0))
	e3:SetCategory(CATEGORY_DAMAGE+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c16677870.cost)
	e3:SetTarget(c16677870.target)
	e3:SetOperation(c16677870.operation)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(16677870,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCountLimit(1,16677870)
	e4:SetCondition(c16677870.spcon)
	e4:SetTarget(c16677870.sptg)
	e4:SetOperation(c16677870.spop)
	c:RegisterEffect(e4)
end
function c16677870.confilter(c)
	return c:IsFaceup() and c:IsSetCard(0x0dac402) and c:IsType(TYPE_SYNCHRO)
end
function c16677870.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(c16677870.confilter,tp,LOCATION_MZONE,0,nil)==1
end
function c16677870.atktg(e,c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsSetCard(0x0dac405)
end
function c16677870.atkfilter(c)
	return c:IsSetCard(0x0dac402)
end
function c16677870.atkval(e,c)
	local tatk=0
	local g=Duel.GetMatchingGroup(c16677870.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		tatk=tatk+tc:GetAttack()
		tc=g:GetNext()
	end
	return tatk
end
function c16677870.costfilter(c)
	return c:IsSetCard(0x0dac402) and c:IsType(TYPE_SYNCHRO) and c:IsFaceup()
end
function c16677870.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c16677870.costfilter,1,nil) end
	local sg=Duel.SelectReleaseGroup(tp,c16677870.costfilter,1,1,nil)
	e:SetLabel(sg:GetFirst():GetAttack())
	Duel.Release(sg,REASON_COST)
end
function c16677870.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c16677870.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetControler()~=tp or not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.Damage(1-tp,e:GetLabel(),REASON_EFFECT)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c16677870.spcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
		and bit.band(e:GetHandler():GetReason(),0x41)==0x41
end
function c16677870.spfilter(c,e,tp)
	return c:IsLevelBelow(9) and c:IsSetCard(0x0dac402) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c16677870.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c16677870.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c16677870.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c16677870.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c16677870.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end