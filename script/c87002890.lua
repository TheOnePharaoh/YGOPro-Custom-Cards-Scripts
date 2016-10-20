--May-Raias Guard
function c87002890.initial_effect(c)
	--position switch
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(87002890,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetCountLimit(1,87002890)
	e1:SetCondition(c87002890.poscon)
	e1:SetOperation(c87002890.posop)
	c:RegisterEffect(e1)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(87002890,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c87002890.spcon)
	e3:SetCost(c87002890.spcost)
	e3:SetTarget(c87002890.sptg)
	e3:SetOperation(c87002890.spop)
	c:RegisterEffect(e3)
	--position change
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(87002890,2))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCondition(c87002890.sccon)
	e4:SetTarget(c87002890.sctg)
	e4:SetOperation(c87002890.scop)
	c:RegisterEffect(e4)
end
function c87002890.poscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsDefensePos()
end
function c87002890.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.ChangePosition(c,POS_FACEUP_ATTACK)
	end
end
function c87002890.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattledGroupCount()>0
end
function c87002890.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c87002890.filter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsSetCard(0xe291ca) and not c:IsCode(87002890) and c:IsCanBeSpecialSummoned(e,200,tp,false,false)
end
function c87002890.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c87002890.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c87002890.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c87002890.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,200,tp,tp,false,false,POS_FACEUP)
		tc:RegisterFlagEffect(tc:GetOriginalCode(),RESET_EVENT+0x1ff0000,0,0)
	end
end
function c87002890.sccon(e,tp,eg,ep,ev,re,r,rp)
	local st=e:GetHandler():GetSummonType()
	return st>=(SUMMON_TYPE_SPECIAL+200) and st<(SUMMON_TYPE_SPECIAL+250)
end
function c87002890.sctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c87002890.scop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,0,POS_FACEUP_ATTACK,0)
	end
end
