--Vocaloid Nekomura - First Diva Movement
function c77662912.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c77662912.spcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--lvchange
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77662912,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c77662912.lvcon)
	e2:SetTarget(c77662912.lvtg)
	e2:SetOperation(c77662912.lvop)
	c:RegisterEffect(e2)
	--synchro limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetValue(c77662912.synlimit)
	c:RegisterEffect(e3)
	--nontuner
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_NONTUNER)
	c:RegisterEffect(e4)
end
function c77662912.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:GetCode()~=77662912
end
function c77662912.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c77662912.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c77662912.lvcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c77662912.lvfilter(c,lv)
	local clv=c:GetLevel()
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and not c:IsType(TYPE_XYZ) and clv>0 and clv~=lv
end
function c77662912.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c77662912.lvfilter(chkc,e:GetHandler():GetLevel()) end
	if chk==0 then return Duel.IsExistingTarget(c77662912.lvfilter,tp,LOCATION_MZONE,0,1,nil,e:GetHandler():GetLevel()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c77662912.lvfilter,tp,LOCATION_MZONE,0,1,1,nil,e:GetHandler():GetLevel())
end
function c77662912.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(tc:GetLevel())
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
end
function c77662912.synlimit(e,c)
	if not c then return false end
	return not c:IsRace(RACE_MACHINE)
end
