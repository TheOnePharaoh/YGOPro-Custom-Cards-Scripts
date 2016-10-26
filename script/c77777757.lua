--Peaceful Eternity
function c77777757.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)	
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,77777757+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(c77777757.condition)
	e1:SetTarget(c77777757.target)
	e1:SetOperation(c77777757.activate)
	c:RegisterEffect(e1)		
end
function c77777757.filter(c)
	return c:IsType(TYPE_MONSTER+TYPE_TRAP+TYPE_SPELL)
end
function c77777757.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c77777757.filter,tp,0,LOCATION_DECK,5,nil)
end

function c77777757.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	local t={}
	local i=1
	local p=1
	local lv=e:GetHandler():GetLevel()
	for i=1,4 do 
		t[p]=i p=p+1
	end
	t[p]=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(77777757,0))
	e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t)))
end

function c77777757.activate(e,tp,eg,ep,ev,re,r,rp)
	local d2=Duel.Draw(1-tp,e:GetLabel(),REASON_EFFECT)
	if d1==0 or d2==0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END,e:GetLabel()*2)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END,e:GetLabel()*2)
	Duel.RegisterEffect(e2,tp)
end