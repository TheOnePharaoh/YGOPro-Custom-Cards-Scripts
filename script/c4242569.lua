--MoonBurst:The Awakened

function c4242569.initial_effect(c)
	--shuffle 3 to deck
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetTarget(c4242569.target1)
	e0:SetOperation(c4242569.operation1)
	c:RegisterEffect(e0)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4242569,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetProperty(EFFECT_FLAG_CHAIN_UNIQUE)
	e2:SetCode(EVENT_CUSTOM+4242569)
	e2:SetCondition(c4242569.spcon)
	e2:SetTarget(c4242569.sptg)
	e2:SetOperation(c4242569.spop)
	c:RegisterEffect(e2)
	--Can't negate summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)
	--pierce
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_PIERCE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c4242569.target1)
	c:RegisterEffect(e4)
--draw when sp summoned
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(4242569,4))
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c4242569.condition)
	e5:SetTarget(c4242569.target)
	e5:SetOperation(c4242569.operation)
	c:RegisterEffect(e5)
end
--Draw when sp summoned
function c4242569.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPreviousLocation()==LOCATION_EXTRA
end
function c4242569.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(5)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c4242569.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end



--local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
--local n=Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
--if n>0 then Duel.Draw(tp,n,REASON_EFFECT) end





--Pierce code
function c4242569.target1(e,c)
	return c:IsCode(4242569)
end





function c4242569.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end

function c4242569.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
	if e:GetHandler():IsLocation(LOCATION_EXTRA) then
		Duel.ConfirmCards(1-tp,e:GetHandler())
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function c4242569.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and Duel.SpecialSummon(e:GetHandler(),0,tp,tp,true,false,POS_FACEUP)>0 then
		e:GetHandler():CompleteProcedure()
	end
end


function c4242569.filter(c)
	return c:IsFaceup() and (c:IsType(TYPE_MONSTER) and c:IsSetCard(0x666))
end
function c4242569.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c4242569.filter,tp,LOCATION_MZONE+LOCATION_EXTRA,0,10,nil) end
	--line above 0,1 is the cards needed to summon
	local g=Duel.GetMatchingGroup(c4242569.filter,tp,LOCATION_MZONE+LOCATION_EXTRA,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c4242569.operation1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c4242569.filter,tp,LOCATION_MZONE+LOCATION_EXTRA+LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,tp,3,POS_FACEDOWN,REASON_EFFECT+REASON_RETURN)
		Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+4242569,e,0,0,tp,0)
	end
end
