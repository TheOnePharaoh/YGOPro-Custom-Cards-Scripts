--Ao Kuang, Descendant of the Nirvana
function c44559800.initial_effect(c)
	c:SetUniqueOnField(1,0,44559800)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,44559800)
	e1:SetTarget(c44559800.target)
	e1:SetOperation(c44559800.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(44559800,0))
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c44559800.damcost)
	e4:SetTarget(c44559800.damtg)
	e4:SetOperation(c44559800.damop)
	c:RegisterEffect(e4)
	--draw
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(44559800,1))
	e5:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCondition(c44559800.dracon)
	e5:SetTarget(c44559800.dratg)
	e5:SetOperation(c44559800.draop)
	c:RegisterEffect(e5)
	--SS
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_SPSUMMON_PROC)
	e6:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e6:SetRange(LOCATION_HAND)
	e6:SetCondition(c44559800.spcon)
	c:RegisterEffect(e6)
end
function c44559800.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c44559800.spfilter(c,e,tp,code)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c44559800.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsExistingMatchingCard(c44559800.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,44559801)
		and Duel.IsExistingMatchingCard(c44559800.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,44559802) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c44559800.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2
		or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c44559800.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,44559801)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectMatchingCard(tp,c44559800.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,44559802)
	g1:Merge(g2)
	if g1:GetCount()==2 then
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c44559800.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c44559800.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dam=e:GetHandler():GetAttack()
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c44559800.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c44559800.dracon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetPreviousLocation(),LOCATION_ONFIELD)>0
end
function c44559800.drafilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2016) or c:IsSetCard(0x2017) or c:IsCode(44559811) or c:IsCode(44559832)
end
function c44559800.dratg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	local ct=Duel.GetMatchingGroupCount(c44559800.drafilter,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct+1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function c44559800.draop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local d=Duel.GetMatchingGroupCount(c44559800.drafilter,p,LOCATION_MZONE,0,nil)+1
	Duel.Draw(p,d,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(p,aux.TRUE,p,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(g,nil,1,REASON_EFFECT)
end
