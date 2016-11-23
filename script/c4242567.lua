--A Full Moon Rises
--Scripted by GameMaster (GM)
function c4242567.initial_effect(c)
	--shuffle 3 to deck
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetTarget(c4242567.target1)
	e0:SetOperation(c4242567.operation1)
	c:RegisterEffect(e0)
	--remove 1 MONSTER WHEN SUMMONED
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4242567,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c4242567.target2)
	e1:SetOperation(c4242567.operation2)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4242567,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetProperty(EFFECT_FLAG_CHAIN_UNIQUE)
	e2:SetCode(EVENT_CUSTOM+4242567)
	e2:SetCondition(c4242567.spcon)
	e2:SetTarget(c4242567.sptg)
	e2:SetOperation(c4242567.spop)
	c:RegisterEffect(e2)
	--Remove self
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4242567,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c4242567.condition3)
	e3:SetTarget(c4242567.target3)
	e3:SetOperation(c4242567.operation3)
	c:RegisterEffect(e3)
end


function c4242567.condition3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c4242567.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function c4242567.operation3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end


function c4242567.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end

function c4242567.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
	if e:GetHandler():IsLocation(LOCATION_EXTRA) then
		Duel.ConfirmCards(1-tp,e:GetHandler())
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function c4242567.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and Duel.SpecialSummon(e:GetHandler(),0,tp,tp,true,false,POS_FACEUP)>0 then
		e:GetHandler():CompleteProcedure()
	end
end



function c4242567.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	local tc=g:GetFirst()
	if tc and tc:IsAbleToRemove() then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
		end
	end

function c4242567.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	end

function c4242567.filter(c)
	return c:IsFaceup() and (c:IsType(TYPE_MONSTER) and c:IsSetCard(0x666))
end
function c4242567.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c4242567.filter,tp,LOCATION_REMOVED,0,3,nil) end
	local g=Duel.GetMatchingGroup(c4242567.filter,tp,LOCATION_REMOVED,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c4242567.operation1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c4242567.filter,tp,LOCATION_REMOVED,0,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,tp,3,POS_FACEDOWN,REASON_EFFECT+REASON_RETURN)
		Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+4242567,e,0,0,tp,0)
	end
end
