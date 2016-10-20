--Zhong Kui, Descendant of the Nirvana
function c44559815.initial_effect(c)
	c:SetUniqueOnField(1,0,44559815)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c44559815.spcon)
	e1:SetOperation(c44559815.spop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,44559815)
	e2:SetTarget(c44559815.target)
	e2:SetOperation(c44559815.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--negate
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(44559815,0))
	e5:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY+CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_SUMMON)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c44559815.negcon)
	e5:SetTarget(c44559815.negtg)
	e5:SetOperation(c44559815.negop)
	c:RegisterEffect(e5)
	--tograve
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(44559815,1))
	e6:SetCategory(CATEGORY_TOGRAVE)
	e6:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e6:SetCode(EVENT_BATTLE_DESTROYING)
	e6:SetCondition(c44559815.tgcon)
	e6:SetTarget(c44559815.tgtg)
	e6:SetOperation(c44559815.tgop)
	c:RegisterEffect(e6)
	--token
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(44559815,2))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_TO_GRAVE)
	e7:SetCondition(c44559815.tokcon)
	e7:SetTarget(c44559815.toktg)
	e7:SetOperation(c44559815.tokop)
	c:RegisterEffect(e7)
end
function c44559815.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2016) or c:IsSetCard(0x2017) and not c:IsCode(44559815) and c:IsAbleToGraveAsCost()
end
function c44559815.spcon(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(c44559815.spfilter,c:GetControler(),LOCATION_MZONE,0,3,nil)
end
function c44559815.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectMatchingCard(tp,c44559815.spfilter,tp,LOCATION_MZONE,0,3,3,nil)
	Duel.SendtoGrave(g,REASON_COST)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(2500)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
end
function c44559815.specfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x2016) and c:GetCode()~=44559815
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c44559815.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c44559815.specfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c44559815.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c44559815.specfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c44559815.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end
function c44559815.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c44559815.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c44559815.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:GetBattleTarget():IsType(TYPE_MONSTER)
end
function c44559815.tgfilter(c)
	return c:IsSetCard(0x2016) or c:IsCode(44559811) and not c:IsCode(44559815) and c:IsAbleToGrave()
end
function c44559815.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c44559815.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c44559815.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c44559815.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c44559815.tokcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetPreviousLocation(),LOCATION_ONFIELD)>0
end
function c44559815.toktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c44559815.tokop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,44559816,0,0x2016,0,0,2,RACE_BEASTWARRIOR,ATTRIBUTE_DARK) then return end
	for i=1,2 do
		local token=Duel.CreateToken(tp,44559815+i)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		token:RegisterEffect(e1,true)
	end
	Duel.SpecialSummonComplete()
end
