--AB King
function c78330013.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DETACH_EVENT)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_INSECT),4,2)
	c:EnableReviveLimit()
	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c78330013.reptg)
	e1:SetValue(c78330013.repval)
	c:RegisterEffect(e1)
	--attack up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(78330013,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_DETACH_MATERIAL)
	e2:SetTarget(c78330013.atktg)
	e2:SetOperation(c78330013.atkop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(78330013,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e3:SetCost(c78330013.spcost)
	e3:SetTarget(c78330013.sptg)
	e3:SetOperation(c78330013.spop)
	c:RegisterEffect(e3)
	--draw
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(78330013,2))
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c78330013.drcon)
	e5:SetTarget(c78330013.drtg)
	e5:SetOperation(c78330013.drop)
	c:RegisterEffect(e5)
end
function c78330013.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsRace(RACE_INSECT)
end
function c78330013.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c78330013.repfilter,1,nil,tp) end
	if e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) and Duel.SelectYesNo(tp,aux.Stringid(78330013,1)) then
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		local g=eg:Filter(c78330013.repfilter,nil,tp)
		if g:GetCount()==1 then
			e:SetLabelObject(g:GetFirst())
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
			local cg=g:Select(tp,1,1,nil)
			e:SetLabelObject(cg:GetFirst())
		end
		return true
	else return false end
end
function c78330013.repval(e,c)
	return c==e:GetLabelObject()
end
function c78330013.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
end
function c78330013.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		e1:SetValue(1000)
		c:RegisterEffect(e1)
	end
end
function c78330013.cfilter(c)
	return c:IsRace(RACE_INSECT) and c:IsAbleToRemoveAsCost()
end
function c78330013.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c78330013.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c78330013.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c78330013.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,1,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c78330013.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),1,tp,tp,false,false,POS_FACEUP)
	end
end
function c78330013.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL
end
function c78330013.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c78330013.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
